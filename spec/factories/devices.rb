FactoryGirl.define do
  factory :device do
    name "Dustcube1"
    api_key "MyString"
    sequence(:device_eui) {|n| "device_#{n}"}
    transport "MyString"
    user

    trait :invalid do
      name nil
    end

    factory :invalid_device, traits: [:invalid]
  end
end
