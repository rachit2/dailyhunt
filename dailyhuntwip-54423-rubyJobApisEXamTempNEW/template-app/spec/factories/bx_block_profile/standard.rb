FactoryBot.define do
  factory :standard, class: BxBlockProfile::Standard do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    rank { 1 }
  end
end
