FactoryBot.define do
  factory :lession, class: BxBlockContentmanagement::Lession do
    heading { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(7) }
    rank { 1 }
  end
end
