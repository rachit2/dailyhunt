FactoryBot.define do
  factory :option, class: BxBlockContentmanagement::Option do
    answer { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(7) }
    is_right { false }
    test_question
  end
end
