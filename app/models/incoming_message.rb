class IncomingMessage < ActiveRecord::Base
  before_validation :extract_transport
  before_validation :extract_lora_data
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
    # seq    P1    P2    PM25    nP1    nP2    Temp.    Hum.
    # 0000  0000  0000  0000  0000  0000  0000  0000
    # If this is a message from Lora
    if self.transport == "lora"
      # Extract values
      byte_array = self.data.chars.each_slice(4).map(&:join)
      # lora_seq_id = byte_array[0]
      p1_ratio = byte_array[1].to_i(16) / 100.0
      p2_ratio = byte_array[2].to_i(16) / 100.0
      pm25_ratio = byte_array[3].to_i(16) / 100.0
      p1_count = byte_array[4].to_i(16)
      p2_count = byte_array[5].to_i(16)
      temperature = byte_array[6].to_i(16) / 10.0
      humidity = byte_array[7].to_i(16) / 10.0

      user = User.where(device_eui: self.device_eui).first

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
        temperature = byte_array[6].to_i(16) / 10.0
        humidity = byte_array[7].to_i(16) / 10.0

      rescue
        print "json parse error"
      end

      user = User.where(api_key: api_key).first
    end
    if user
      user.measurements.create! p1_ratio: p1_ratio,
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
        self.status = "processed"
      else
        self.transport = 'lora'
      end
    rescue
      self.status = "json_parse_error"
    end
  end

  def extract_lora_data
    if self.transport == "lora"
      begin
        json_data = JSON.parse(self.body)

        self.gateway_eui = json_data['gatewayEui']
        self.device_eui = json_data['deviceEui']
        self.packet_time = json_data['packetTime']
        self.tmst = json_data['tmst']
        self.frequency = json_data['frequency']
        self.data_rate = json_data['dataRate']
        self.rssi = json_data['rssi']
        self.snr = json_data['snr']
        begin
          self.data = Base64.decode64(json_data['data']).unpack("H*").first
        rescue
          self.data = "Decode error."
        end
        self.status = "processed"
      rescue
        self.status = "json_parse_error"
      end
    end
  end
end
