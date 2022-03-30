FactoryBot.define do
  factory :blog_content_type, class: BxBlockContentmanagement::ContentType do
    name { "Blogs" }
    type { "Text" }
    identifier { "blog" }
  end
end
