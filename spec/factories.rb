FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Чувак #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password '123456'
    password_confirmation '123456'
  end
end
