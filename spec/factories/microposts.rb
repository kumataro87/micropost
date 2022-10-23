FactoryBot.define do
  factory :micropost do
    content { "I like pizza"}
    created_at { Time.zone.now }
    association :user
  end

  factory :other_micropost, class: Micropost do
    sequence(:content) { |n| Faker::Lorem.sentence(word_count: 5) }
    sequence(:created_at) { |n| 10.minutes.ago }
    association :user
  end
end
