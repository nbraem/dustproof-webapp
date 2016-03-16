class IncomingMessage < ActiveRecord::Base
  before_validation :extract_lora_data
  validates :timestamp, presence: true
  validate :is_not_duplicate_packet, on: :create
  after_create :convert_to_measurement

  def human_gateway
    case self.gateway_eui
    when "AA555A0000098006"
      "Middelheim"
    when "AA555A0000094194"
      "Walem"
    when "AA555A0000094200"
      "Boom A12"
    else
      self.gateway_eui
    end
  end

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
    if self.timestamp
      if IncomingMessage.where("data = ? AND device_eui = ? AND timestamp >= ?",
          self.data,
          self.device_eui,
          (self.timestamp - 2.minutes).to_s(:db)).any?
        errors[:base] << "This is a duplicate packet."
      end
    end
  end

  def convert_to_measurement
    # If this is a message from Lora
    if self.device_eui.present?
      # Extract values
      byte_array = self.data.chars.each_slice(4).map(&:join)
      # lora_seq_id = byte_array[0]
      p1_ratio = byte_array[1].to_i(16) / 100.0
      p2_ratio = byte_array[2].to_i(16) / 100.0
      p1_count = byte_array[3].to_i(16)
      p2_count = byte_array[4].to_i(16)

      user = User.where(device_eui: self.device_eui).first
      if user
        user.measurements.create! p1_ratio: p1_ratio,
                                  p2_ratio: p2_ratio,
                                  p1_count: p1_count,
                                  p2_count: p2_count,
                                  timestamp: self.timestamp,
                                  transport: "lora"
      end
    end
  end

  private

  def extract_lora_data
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