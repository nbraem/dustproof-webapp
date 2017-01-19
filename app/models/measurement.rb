class Measurement < ActiveRecord::Base
  validates :timestamp, presence: true
  validates :pm25_ratio, presence: true
  validates :p1_ratio, presence: true
  validates :p2_ratio, presence: true

  before_save :validate_measurement

  belongs_to :user

  private

  def validate_measurement
    begin
      if (self.p1_ratio < self.p2_ratio) ||
          (self.temperature < -40.0 || self.temperature > 125.0) ||
          (self.humidity < 0.0 || self.humidity > 100.0)
        self.is_valid = false
      else
        self.is_valid = true
      end
    rescue
      self.is_valid = false
    end
    return true
  end
end
