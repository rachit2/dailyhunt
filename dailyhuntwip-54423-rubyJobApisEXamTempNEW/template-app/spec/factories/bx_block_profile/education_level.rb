FactoryBot.define do
  factory :education_level, class: BxBlockProfile::EducationLevel do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    rank { 1 }
    level { BxBlockProfile::EducationLevel.levels.keys.sample }
  end
end
