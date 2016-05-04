class Measurement < ActiveRecord::Base
  FILTER_WEIGHT = 30.0
  CUBIC_FEET_IN_CUBIC_METER = 35.3147
  validates :timestamp, presence: true
  validates :pm25_ratio, presence: true
  validates :p1_ratio, presence: true
  validates :p2_ratio, presence: true
  validates :p1_concentration, presence: true
  validates :p1_concentration_filtered, presence: true
  validates :p2_concentration, presence: true
  validates :p2_concentration_filtered, presence: true

  belongs_to :user

  before_validation :calculate_concentration!

  def calculate_concentration!
    if self.p1_ratio && self.p2_ratio
      self.p1_concentration = (1.1 * self.p1_ratio ** 3 -
                              3.8 * self.p1_ratio ** 2 +
                              520 * self.p1_ratio * 100 * CUBIC_FEET_IN_CUBIC_METER).round
      self.p2_concentration = (1.1 * self.p2_ratio ** 3 -
                              3.8 * self.p2_ratio ** 2 +
                              520 * self.p2_ratio * 100 * CUBIC_FEET_IN_CUBIC_METER).round

      previous_measurement = Measurement.where(user_id: self.user_id)
                              .where("timestamp < ?", self.timestamp)
                              .order(timestamp: :desc).first

      if previous_measurement &&
        previous_measurement.p1_concentration_filtered &&
        previous_measurement.p2_concentration_filtered
        self.p1_concentration_filtered = ((self.p1_concentration +
                                          previous_measurement.p1_concentration_filtered *
                                          (FILTER_WEIGHT - 1.0)) /
                                          FILTER_WEIGHT).round
        self.p2_concentration_filtered = ((self.p2_concentration +
                                          previous_measurement.p2_concentration_filtered *
                                          (FILTER_WEIGHT - 1.0)) /
                                          FILTER_WEIGHT).round
      else
        self.p1_concentration_filtered = self.p1_concentration
        self.p2_concentration_filtered = self.p2_concentration
      end
    end
  end
end
