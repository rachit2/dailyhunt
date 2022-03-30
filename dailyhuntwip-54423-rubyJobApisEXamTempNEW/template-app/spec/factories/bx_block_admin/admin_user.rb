FactoryBot.define do
  factory :admin_user, class: BxBlockAdmin::AdminUser do
    email {"admin@careerhunt.com"}
    password {"careerhunt@321"}
    association :role
  end
end
