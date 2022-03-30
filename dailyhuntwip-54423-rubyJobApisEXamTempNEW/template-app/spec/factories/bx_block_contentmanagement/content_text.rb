FactoryBot.define do
  factory :content_text, class: BxBlockContentmanagement::ContentText do
  	content { Faker::Alphanumeric.unique.alphanumeric(7) }
    headline { Faker::Alphanumeric.unique.alphanumeric(7) }
    # tags { Faker::Alphanumeric.unique.alphanumeric(7) }
    hyperlink { Faker::Alphanumeric.unique.alphanumeric(20) }
    # publishing_date_and_time { DateTime.now }
    affiliation { Faker::Alphanumeric.unique.alphanumeric(7) }
    # publishing_date_and_time {Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default)}
  end
end
