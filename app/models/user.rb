require "shared_accessor"

class User < ActiveRecord::Base
  include SharedAccessor::FullName

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :registerable,
         :rememberable, :trackable, :validatable, :confirmable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  has_many :measurements, dependent: :destroy
  has_many :average_hourly_measurements
  has_many :average_daily_measurements
  has_many :devices, dependent: :destroy

  before_create :generate_api_key

  def remember_me
    true
  end

  def generate_api_key
    self.api_key = loop do
      random_api_key = SecureRandom.urlsafe_base64(nil, false)
      break random_api_key unless User.exists?(api_key: random_api_key)
    end
  end
end
