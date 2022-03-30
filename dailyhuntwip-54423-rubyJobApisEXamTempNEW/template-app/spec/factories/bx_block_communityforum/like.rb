FactoryBot.define do
  factory :like, class: BxBlockCommunityforum::Like do
    association :likeable, factory: :question
    account
    is_like {true}
  end
end
