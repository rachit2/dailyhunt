FactoryBot.define do
  factory :college, class: BxBlockProfile::College do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    rank { 1 }
  end
end
