FactoryBot.define do
  factory :application_message, class: BxBlockLanguageoptions::ApplicationMessage do
    name { Faker::Name.unique.name }
    message {Faker::Name.unique.name}  
  end
end