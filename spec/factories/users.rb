FactoryBot.define do
  factory :user do
    name { 'Szuki Taro' }
    email { 'Taro@example.com' }
    password {'password'} 
    password_confirmation { 'password' }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :other_user, class: User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    activated_at { Time.zone.now }
  end
end
