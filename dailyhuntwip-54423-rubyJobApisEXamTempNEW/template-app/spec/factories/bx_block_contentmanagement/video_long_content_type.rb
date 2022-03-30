FactoryBot.define do
  factory :video_long_content_type, class: BxBlockContentmanagement::ContentType do
    name { "Videos (full length)" }
    type { "Videos" }
    identifier { "video_full" }
  end
end