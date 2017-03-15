class Measurement < ActiveRecord::Base
  include ActiveModel::Serialization

  belongs_to :device

  def chart_datetime
    timestamp.to_i * 1000 if timestamp
  end

  def as_csv(options={})
    attributes.slice('timestamp',
                     'transport',
                     'seq_num',
                     'loss',
                     'p1_ratio',
                     'p2_ratio',
                     'pm25_ratio',
                     'p1_count',
                     'p2_count',
                     'temperature',
                     'humidity')
  end
end
