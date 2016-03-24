class Measurement < ActiveRecord::Base
  validates :timestamp, presence: true
  validates :pm25_ratio, presence: true
  validates :p2_ratio, presence: true

  belongs_to :user
end
