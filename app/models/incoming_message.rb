class IncomingMessage < ActiveRecord::Base
  before_validation :extract_identifier
  before_validation :calculate_packet_loss
  validates :timestamp, presence: true
  validates :identifier, presence: true
  validate :is_not_duplicate_packet, on: :create
  after_create :convert_to_measurement

  def device_eui
    if proximus?
      self.body['DevEUI_uplink']['DevAddr']
    else
      self.body['devAddr']
    end
  end

  def gateway_eui
    if lora?
      if proximus?
        'Proximus LoRa network'
      else
        self.body['gatewayEui']
      end
    else
      "WiFi"
    end
  end

  def frequency
    self.body['frequency'] unless proximus?
  end

  def rssi
    if proximus?
      self.body['DevEUI_uplink']['LrrRSSI']
    else
      self.body['rssi']
    end
  end

  def snr
    if proximus?
      self.body['DevEUI_uplink']['LrrSNR']
    else
      self.body['snr']
    end
  end

  def data
    if wifi?
      self.body["measurement"]
    else
      if proximus?
        self.body['DevEUI_uplink']['payload_hex']
      else
        begin
          Base64.decode64(self.body['payload']).unpack("H*").first
        rescue
          ""
        end
      end
    end
  end

  def sequence_number
    byte_array = self.data.chars.each_slice(4).map(&:join)
    byte_array[0].to_i(16)
  end

  def proximus?
    self.body.key?("DevEUI_uplink")
  end

  def wifi?
    self.body["transport"] == "wifi"
  end

  def lora?
    !wifi?
  end

  def is_not_duplicate_packet
    return true if wifi?
    if self.timestamp
      if IncomingMessage.where("body @> ? AND timestamp >= ?",
          {fcnt: self.body["fcnt"], devAddr: self.device_eui}.to_json,
          (self.timestamp - 1.minute).to_s(:db)).any?
        errors[:base] << "This is a duplicate packet."
      end
    end
  end

  def convert_to_measurement
    # Measurements contain 8 groups of 2 bytes:
    # seq   P1    P2    PM25  nP1   nP2   Temp. Hum.
    # 0000  0000  0000  0000  0000  0000  0000  0000

    # Extract values
    byte_array = self.data.chars.each_slice(4).map(&:join)
    if byte_array.size == 8
      # seq_id = byte_array[0].to_i(16)
      p1_ratio = byte_array[1].to_i(16) / 100.0
      p2_ratio = byte_array[2].to_i(16) / 100.0
      pm25_ratio = byte_array[3].to_i(16) / 100.0
      p1_count = byte_array[4].to_i(16)
      p2_count = byte_array[5].to_i(16)
      temperature = byte_array[6].to_i(16)
      # Account for the fact that the temperature is a signed value
      temperature = ((temperature & ~(1 << 15)) - (temperature & (1 << 15))) / 10.0
      humidity = byte_array[7].to_i(16) / 10.0

      # Find the appropriate device
      if self.device_eui.present?
        device = Device.where(transport: "lora").where(device_eui: self.device_eui).first
      elsif self.body["api_key"].present?
        device = Device.where(transport: "wifi").where(api_key: self.body["api_key"]).first
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
                                    transport: wifi? ? "wifi" : "lora"
      end
    end
  end

  private

  def extract_identifier
    self.identifier = self.body["api_key"] ||
      (self.body['DevEUI_uplink']['DevAddr'] if self.body['DevEUI_uplink']) ||
      self.body['devAddr']
  end

  def calculate_packet_loss
    if self.sequence_number > 0
      previous_message = IncomingMessage.order(timestamp: :desc).where(identifier: self.identifier).first
      if previous_message
        if previous_message.sequence_number < self.sequence_number
          missing_packets = self.sequence_number - previous_message.sequence_number - 1
          self.lost_packets = missing_packets if missing_packets <= 60
        end
      end
    end
  end
end
