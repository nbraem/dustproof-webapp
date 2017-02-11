# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :measurement do
    pm25_ratio 0.55
    p1_ratio 6.20
    p2_ratio 3.15
    temperature 10.0
    humidity 49.0
    sequence(:seq_num)

    timestamp Time.now
    device

    trait :invalid do
      p2_ratio nil
    end

    factory :invalid_measurement, traits: [:invalid]
  end
end
