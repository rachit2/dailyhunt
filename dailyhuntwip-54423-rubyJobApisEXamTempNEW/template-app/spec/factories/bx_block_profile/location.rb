FactoryBot.define do
  factory :location, class: BxBlockProfile::Location do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    latitude  {  41.804 }
    longitude  {  12.3015 }
  end
end
