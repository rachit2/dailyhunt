FactoryBot.define do
  factory :job_category, class: BxBlockJobs::JobCategory do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
  end
end
