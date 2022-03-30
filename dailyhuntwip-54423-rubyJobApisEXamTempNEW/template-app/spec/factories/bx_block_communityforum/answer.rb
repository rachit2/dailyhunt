FactoryBot.define do
  factory :answer, class: BxBlockCommunityforum::Answer do
    title { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
    account
    question
  end
end
