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

  has_many :devices, dependent: :destroy

  def remember_me
    true
  end
end
