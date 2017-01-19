class Measurement < ActiveRecord::Base
  validates :timestamp, presence: true
  validates :pm25_ratio, presence: true
  validates :p1_ratio, presence: true
  validates :p2_ratio, presence: true

  before_save :validate_measurement

  belongs_to :user

  private

  def validate_measurement
    if self.p1_ratio < self.p2_ratio
      self.is_valid = false
    else
      self.is_valid = true
    end
    return true
  end
end
