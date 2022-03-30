FactoryBot.define do
  factory :comment, class: BxBlockCommunityforum::Comment do
    account
    association :commentable, factory: :question
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
  end
end