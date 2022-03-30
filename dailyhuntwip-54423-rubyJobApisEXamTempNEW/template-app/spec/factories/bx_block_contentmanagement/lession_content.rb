FactoryBot.define do
  factory :lession_content, class: BxBlockContentmanagement::LessionContent do
    heading { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(7) }
    content_type { 4 }
    duration { '0:10' }
    video { Rails.root.join("#{Rails.root}/app/assets/videos/java.mp4").open }
    rank { 1 }
  end
end
