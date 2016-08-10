FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    password "password"

    transient do
      bucket_count 0
    end

    after(:create) do |_user, evaluator|
      create_list(:bucket_list, evaluator.bucket_count)
    end
  end
end
