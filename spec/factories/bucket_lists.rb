FactoryGirl.define do
  factory :bucket_list do
    sequence(:name) { |n| "name#{n}" }
  end
end
