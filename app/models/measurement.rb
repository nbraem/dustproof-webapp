class Measurement < ActiveRecord::Base
  validates :seq_id, presence: true
  validates :timestamp, presence: true
  validates :p1_lpo, presence: true
  validates :p2_lpo, presence: true

  belongs_to :user
end
