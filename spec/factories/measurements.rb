# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :measurement do
    pm25_ratio 0.55
    p1_ratio 1.20
    p2_ratio 0.10
    timestamp Time.now
    user

    trait :invalid do
      p2_ratio nil
    end

    factory :invalid_measurement, traits: [:invalid]
  end
end
