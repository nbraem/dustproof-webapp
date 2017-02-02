class Device < ActiveRecord::Base
  validates :name, presence: true
  validates :transport, presence: true

  belongs_to :user
  has_many :measurements, dependent: :destroy

  before_create :generate_api_key

  protected

  def generate_api_key
    self.api_key = loop do
      random_api_key = SecureRandom.urlsafe_base64(nil, false)
      break random_api_key unless Device.exists?(api_key: random_api_key)
    end
  end
end
