FactoryBot.define do
  factory :account, class: AccountBlock::Account do
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    country_code { Faker::Address.country_code }
    email { Faker::Internet.email }
    activated { false }
    device_id { nil }
    unique_auth_id { nil }
    password_digest { "ghfgf" }
    type { "SmsAccount" }
    user_name { nil }
    role_id { nil }
    city { nil }
    app_language_id {nil}
    full_phone_number { "+91987#{Faker::Number.number(7)}" }
    last_visit_at {nil}
  end
end
