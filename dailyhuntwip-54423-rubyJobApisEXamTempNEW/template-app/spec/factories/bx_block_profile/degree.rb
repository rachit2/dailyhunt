FactoryBot.define do
  factory :degree, class: BxBlockProfile::Degree do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    rank { 1 }
  end
end
