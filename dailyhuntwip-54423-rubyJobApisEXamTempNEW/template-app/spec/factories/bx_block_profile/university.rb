FactoryBot.define do
  factory :university, class: BxBlockProfile::University do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    is_featured { false }
    location
    median_salary { 20000.0 }
    total_fees_min { 20000.0 }
    total_fees_max { 20000.0 }
    course_rating { 2.50 }
  end
end
