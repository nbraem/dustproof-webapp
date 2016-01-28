# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    sequence(:email) { |n| "person#{n}@example.com" }
    password "secret"

    trait :admin do
      first_name "Jane"
      last_name "Doe"
      admin true
    end

    trait :invalid do
      email nil
    end

    factory :admin_user, traits: [:admin]
    factory :invalid_user, traits: [:invalid]
  end
end
