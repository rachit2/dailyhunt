# frozen_string_literal: true

FactoryBot.define do
  factory :exam_update, class: BxBlockContentmanagement::ExamUpdate do
    date { Date.today }
    update_message { Faker::Alphanumeric.unique.alphanumeric(20) }
    link { Faker::Internet.url }
    exam
  end
end
