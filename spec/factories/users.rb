FactoryBot.define do
  factory :user do
    name { 'Szuki Taro' }
    email { 'taro@example.com' }
    password {'password'} 
    password_confirmation { 'password' }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }

    trait :user_with_followed do
      after(:create) do |user|
        10.times do
          user.following << create(:other_user) 
        end
      end
    end

    trait :user_with_follower do
      after(:create) do |user|
        10.times do
          user.followers << create(:other_user) 
        end
      end
    end
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
