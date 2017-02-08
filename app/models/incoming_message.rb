class IncomingMessage < ActiveRecord::Base
  before_validation :extract_transport
  before_validation :extract_wifi_data
  before_validation :extract_lora_data
  before_validation :calculate_packet_loss
  validates :timestamp, presence: true
  validate :is_not_duplicate_packet, on: :create
  after_create :convert_to_measurement

  def self.to_csv
    columns = %w[id gateway_eui device_eui timestamp packet_time tmst frequency
      data_rate rssi snr data comments]
    CSV.generate do |csv|
      csv << columns
      all.each do |incoming_message|
        csv << incoming_message.attributes.values_at(*columns)
      end
    end
  end

  def is_not_duplicate_packet
    if self.timestamp && self.transport == "lora"
      if IncomingMessage.where("data = ? AND device_eui = ? AND timestamp >= ?",
          self.data,
          self.device_eui,
          (self.timestamp - 2.minutes).to_s(:db)).any?
        errors[:base] << "This is a duplicate packet."
      end
    end
  end

  def convert_to_measurement
    # Lora packets contain 8 groups of 2 bytes:
    # seq   P1    P2    PM25  nP1   nP2   Temp. Hum.
    # 0000  0000  0000  0000  0000  0000  0000  0000
    # If this is a message from Lora
    if self.transport == "lora"
      begin
        # Extract values
        byte_array = self.data.chars.each_slice(4).map(&:join)
        # lora_seq_id = byte_array[0].to_i(16)
        p1_ratio = byte_array[1].to_i(16) / 100.0
        p2_ratio = byte_array[2].to_i(16) / 100.0
        pm25_ratio = byte_array[3].to_i(16) / 100.0
        p1_count = byte_array[4].to_i(16)
        p2_count = byte_array[5].to_i(16)
        temperature = byte_array[6].to_i(16)
        # Account for the fact that the temperature is a signed value
        temperature = ((temperature & ~(1 << 15)) - (temperature & (1 << 15))) / 10.0
        humidity = byte_array[7].to_i(16) / 10.0
      rescue
        p1_ratio = 0.0
        p2_ratio = 0.0
        pm25_ratio = 0.0
        p1_count = 0
        p2_count = 0
        temperature = 0.0
        humidity = 0.0
      end

      if self.device_eui.present?
        device = Device.where(transport: "lora").where(device_eui: self.device_eui).first
      end

    # If this is a message from WiFi
    elsif self.transport == "wifi"
      begin
        json_data = JSON.parse(self.body)

        api_key = json_data['api_key']

        measurement = json_data['measurement']
        # Extract values
        byte_array = measurement.chars.each_slice(4).map(&:join)
        # wifi_seq_id = byte_array[0]
        p1_ratio = byte_array[1].to_i(16) / 100.0
        p2_ratio = byte_array[2].to_i(16) / 100.0
        pm25_ratio = byte_array[3].to_i(16) / 100.0
        p1_count = byte_array[4].to_i(16)
        p2_count = byte_array[5].to_i(16)
        temperature = byte_array[6].to_i(16)
        # Account for the fact that the temperature is a signed value
        temperature = ((temperature & ~(1 << 15)) - (temperature & (1 << 15))) / 10.0
        humidity = byte_array[7].to_i(16) / 10.0

      rescue
        print "json parse error"
      end

      device = Device.where(transport: "wifi").where(api_key: api_key).first
    end
    if device
      device.measurements.create! p1_ratio: p1_ratio,
                                  p2_ratio: p2_ratio,
                                  pm25_ratio: pm25_ratio,
                                  p1_count: p1_count,
                                  p2_count: p2_count,
                                  temperature: temperature,
                                  humidity: humidity,
                                  timestamp: self.timestamp,
                                  transport: self.transport
    end
  end

  private

  def extract_transport
    begin
      json_data = JSON.parse(self.body)

      if json_data.key?("transport")
        self.transport = json_data['transport']
      else
        self.transport = 'lora'
      end
    rescue
      self.status = "json_parse_error"
    end
  end

  def extract_wifi_data
    if self.transport == "wifi"
      begin
        json_data = JSON.parse(self.body)

        if json_data['api_key'].present?
          self.api_key = Digest::SHA1.hexdigest json_data['api_key']
        end

        self.status = "processed"
      rescue
        self.status = "json_parse_error"
      end
    end
  end

  def extract_lora_data
    if self.transport == "lora"
      begin
        json_data = JSON.parse(self.body)

        if json_data['DevEUI_uplink'].present?
          # Proximus LoRa network
          self.gateway_eui = 'Proximus LoRa network'
          self.device_eui = json_data['DevEUI_uplink']['DevAddr']
          self.packet_time = json_data['DevEUI_uplink']['Time']
          self.rssi = json_data['DevEUI_uplink']['LrrRSSI']
          self.snr = json_data['DevEUI_uplink']['LrrSNR']
          self.data = json_data['DevEUI_uplink']['payload_hex']
          self.status = "processed"
        else
          # Wireless Thing LoRa network
          self.gateway_eui = json_data['gatewayEui']
          self.device_eui = json_data['devAddr']
          self.packet_time = json_data['packetTime']
          self.tmst = json_data['tmst']
          self.frequency = json_data['frequency']
          self.data_rate = json_data['dataRate']
          self.rssi = json_data['rssi']
          self.snr = json_data['snr']
          begin
            self.data = Base64.decode64(json_data['payload']).unpack("H*").first
          rescue
            self.data = "Decode error."
          end
          self.status = "processed"
        end
      rescue
        self.status = "json_parse_error"
      end
    end
  end

  def calculate_packet_loss
    if self.transport == "lora"
      byte_array = self.data.chars.each_slice(4).map(&:join)
      current_sequence_number = byte_array[0].to_i(16)

      if current_sequence_number > 0
        previous_message = IncomingMessage.order(timestamp: :desc).where(device_eui: self.device_eui).first
        if previous_message
          byte_array = previous_message.data.chars.each_slice(4).map(&:join)
          previous_sequence_number = byte_array[0].to_i(16)
          if previous_sequence_number < current_sequence_number
            missing_packets = current_sequence_number - previous_sequence_number - 1
            self.lost_packets = missing_packets if missing_packets <= 60
          end
        end
      end
    elsif self.transport == "wifi"
      json_data = JSON.parse(self.body)
      api_key_hash = Digest::SHA1.hexdigest json_data["api_key"]
      byte_array = json_data["measurement"].chars.each_slice(4).map(&:join)
      current_sequence_number = byte_array[0].to_i(16)

      if current_sequence_number > 0
        previous_message = IncomingMessage.order(timestamp: :desc).where(api_key: api_key_hash).first
        if previous_message
          json_data = JSON.parse(previous_message.body)
          byte_array = json_data["measurement"].chars.each_slice(4).map(&:join)
          previous_sequence_number = byte_array[0].to_i(16)
          if previous_sequence_number < current_sequence_number
            missing_packets = current_sequence_number - previous_sequence_number - 1
            self.lost_packets = missing_packets if missing_packets <= 60
          end
        end
      end
    end
  end
end
