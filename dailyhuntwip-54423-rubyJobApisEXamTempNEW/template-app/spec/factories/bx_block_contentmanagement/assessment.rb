FactoryBot.define do
  factory :assessment, class: BxBlockContentmanagement::Assessment do
    heading { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
    language
    is_popular { true }
    is_trending {true }
    sub_category
    category
  end
end
