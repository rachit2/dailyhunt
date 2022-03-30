FactoryBot.define do
  factory :board, class: BxBlockProfile::Board do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    rank { 1 }
  end
end
