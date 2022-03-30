FactoryBot.define do
  factory :quiz, class: BxBlockContentmanagement::Quiz do
    language
    heading { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
    quiz_description { Faker::Alphanumeric.unique.alphanumeric(20) }
    is_popular { true }
    is_trending { false }
    timer { '10:50' }
    sub_category
    category
  end
end
