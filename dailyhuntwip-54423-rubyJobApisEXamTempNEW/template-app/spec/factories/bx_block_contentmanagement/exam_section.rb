# frozen_string_literal: true

FactoryBot.define do
  factory :exam_section, class: BxBlockContentmanagement::ExamSection do
    title { Faker::Alphanumeric.unique.alphanumeric(7) }
    body { Faker::Alphanumeric.unique.alphanumeric(20) }
    exam
  end
end
