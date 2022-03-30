FactoryBot.define do
  factory :subject, class: BxBlockProfile::Subject do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    rank { 1 }
  end
end
