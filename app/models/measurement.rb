class Measurement < ActiveRecord::Base
  before_validation :calculate_loss
  validates :timestamp, presence: true
  validates :pm25_ratio, presence: true
  validates :p1_ratio, presence: true
  validates :p2_ratio, presence: true
  validates :seq_num, presence: true
  validates :loss, presence: true
  validate :is_not_duplicate, on: :create

  before_save :validate_measurement

  belongs_to :device

  def chart_datetime
    timestamp.to_i * 1000 if timestamp
  end

  private

  def validate_measurement
    if self.p1_ratio < self.p2_ratio
      self.is_valid = false
    else
      self.is_valid = true
    end
    return true
  end

  def is_not_duplicate
    if seq_num && device_id
      if self.device.measurements.where("device_id = ? AND seq_num = ? AND timestamp >= ?", device_id,
        seq_num, (self.timestamp - 1.minute).to_s(:db)).any?
        errors[:base] << "This is a duplicate measurement."
      end
    end
  end

  def calculate_loss
    if seq_num && seq_num > 0
      previous_measurement = self.device.measurements.order(timestamp: :desc).first
      if previous_measurement && previous_measurement.seq_num < seq_num
        self.loss = seq_num - previous_measurement.seq_num - 1
      end
    end
  end
end
