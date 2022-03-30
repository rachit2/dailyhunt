FactoryBot.define do
  factory :educational_course, class: BxBlockProfile::EducationalCourse do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    rank { 1 }
  end
end
