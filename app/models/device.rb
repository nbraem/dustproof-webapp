class Device < ActiveRecord::Base
  validates :name, presence: true
  validates :transport, presence: true
  validates :device_eui, uniqueness: true

  belongs_to :user
  has_many :measurements, dependent: :destroy
  has_many :average_hourly_measurements
  has_many :average_daily_measurements

  before_create :generate_api_key

  def generate_api_key
    self.api_key = loop do
      random_api_key = SecureRandom.urlsafe_base64(nil, false)
      break random_api_key unless Device.exists?(api_key: random_api_key)
    end
  end
end
