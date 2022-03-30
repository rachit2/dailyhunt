FactoryBot.define do
  factory :course, class: BxBlockContentmanagement::Course do
    language
    heading { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(7) }
    price { 500 }
    is_popular { false }
    is_trending { false }
    is_premium { false }
    thumbnail { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark.png").open }
    video { Rails.root.join("#{Rails.root}/app/assets/videos/java.mp4").open }
    rank { 1 }
    sub_category
    category
  end
end
