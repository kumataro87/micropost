FactoryBot.define do
  factory :user do
    sequence(:name)  { |n| "test#{n}"}
    sequence(:email) { |n| "test#{n}@example.com"}

    password {'password'} 
    password_confirmation { 'password' }
  end

  factory :continuous_users, class: User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
