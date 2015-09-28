FactoryGirl.define do
  factory :user do
    name     'Andrey Kumykov'
    email    'aakumykov@yandex.ru'
    password 'qwerty'
    password_confirmation 'qwerty'
  end
end