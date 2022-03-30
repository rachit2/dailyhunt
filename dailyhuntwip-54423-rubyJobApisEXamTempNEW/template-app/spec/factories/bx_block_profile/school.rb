FactoryBot.define do
  factory :school, class: BxBlockProfile::School do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    location
    board
  end
end
