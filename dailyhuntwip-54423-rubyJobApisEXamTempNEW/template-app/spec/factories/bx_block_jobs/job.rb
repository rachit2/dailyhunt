FactoryBot.define do
  factory :job, class: BxBlockJobs::Job do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    heading { Faker::Alphanumeric.unique.alphanumeric(20) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
    requirement { Faker::Alphanumeric.unique.alphanumeric(20) }
    experience {1}
    job_type { 1 }
    job_category
  end
end
