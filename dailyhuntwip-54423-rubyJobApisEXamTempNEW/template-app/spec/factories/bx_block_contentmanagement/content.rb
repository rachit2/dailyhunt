FactoryBot.define do
  factory :content, class: BxBlockContentmanagement::Content do
    sub_category
    category
    content_type
    language
    publish_date { DateTime.now}
    status { 'publish' }
    # publishing_date_and_time {Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default)}
  	trait :reindex do
      after(:create) do |content, _evaluator|
        content.reindex(refresh: true)
      end
    end
  end
end
