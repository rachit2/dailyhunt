FactoryBot.define do
  factory :language, class: BxBlockLanguageoptions::Language do
    name { Faker::Name.unique.name }
    language_code {Faker::Name.unique.name}
  end
end
