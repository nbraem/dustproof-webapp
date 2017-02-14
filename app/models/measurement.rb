class Measurement < ActiveRecord::Base
  belongs_to :device

  def chart_datetime
    timestamp.to_i * 1000 if timestamp
  end

end
