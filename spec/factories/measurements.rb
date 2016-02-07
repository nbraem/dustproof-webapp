# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :measurement do
    sequence(:seq_id)
    p1_lpo 999999
    p2_lpo 888888
    timestamp Time.now
    user

    trait :invalid do
      p2_lpo nil
    end

    factory :invalid_measurement, traits: [:invalid]
  end
end
