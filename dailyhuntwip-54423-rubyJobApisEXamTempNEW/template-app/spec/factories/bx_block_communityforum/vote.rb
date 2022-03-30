FactoryBot.define do
  factory :vote, class: BxBlockCommunityforum::Vote do
    account
    question
  end
end
