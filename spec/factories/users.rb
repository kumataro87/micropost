FactoryBot.define do
  factory :user do
    name { 'Szuki Taro' }
    email { 'Taro@example.com' }
    password {'password'} 
    password_confirmation { 'password' }
    admin { true }
  end

  factory :other_user, class: User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
