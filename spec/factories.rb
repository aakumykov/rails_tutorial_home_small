FactoryGirl.define do
  factory :user do
    name     'Example User'
    email    'example@railstutorial.org'
    password 'qwerty'
    password_confirmation 'qwerty'
  end
end