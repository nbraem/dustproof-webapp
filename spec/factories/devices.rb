FactoryGirl.define do
  factory :device do
    name "Dustcube1"
    api_key "MyString"
    device_eui "MyString"
    transport "MyString"
    user

    trait :invalid do
      name nil
    end

    factory :invalid_device, traits: [:invalid]
  end
end
