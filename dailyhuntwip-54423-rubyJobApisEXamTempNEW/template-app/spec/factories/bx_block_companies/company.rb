FactoryBot.define do
  factory :company, class: BxBlockCompany::Company do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    about { Faker::Alphanumeric.unique.alphanumeric(20) }
  end
end
