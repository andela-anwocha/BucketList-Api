FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    password "password"

    transient do
      bucket_count 2
    end

    after(:create) do |user, evaluator|
      count = evaluator.bucket_count
      user.update(bucket_lists: create_list(:bucket_list, count))
    end
  end
end
