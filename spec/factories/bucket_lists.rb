FactoryGirl.define do
  factory :bucket_list do
    sequence(:name) { |n| "Humanitarian #{n}" }

    transient do
      item_count 2
    end

    after(:create) do |bucket_list, evaluator|
      count = evaluator.item_count
      bucket_list.update(items: FactoryGirl.create_list(:item, count))
    end
  end
end
