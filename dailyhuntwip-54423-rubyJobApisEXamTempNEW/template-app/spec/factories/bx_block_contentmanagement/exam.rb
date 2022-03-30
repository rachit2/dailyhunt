# frozen_string_literal: true

FactoryBot.define do
  factory :exam, class: BxBlockContentmanagement::Exam do
    heading { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
    from { Date.today }
    to { Date.today + 1.days }
    category
    sub_category
    content_provider {}
  end
end
