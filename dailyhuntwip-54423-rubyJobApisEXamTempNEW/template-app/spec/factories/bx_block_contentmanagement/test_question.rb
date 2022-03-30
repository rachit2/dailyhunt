FactoryBot.define do
  factory :test_question, class: BxBlockContentmanagement::TestQuestion do
    question { Faker::Alphanumeric.unique.alphanumeric(20) }
    options_number { 1 }
    association :questionable, factory: :assessment
  end
end
