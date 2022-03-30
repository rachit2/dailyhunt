FactoryBot.define do
  factory :domain_work_function, class: BxBlockProfile::DomainWorkFunction do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    rank { 1 }
  end
end
