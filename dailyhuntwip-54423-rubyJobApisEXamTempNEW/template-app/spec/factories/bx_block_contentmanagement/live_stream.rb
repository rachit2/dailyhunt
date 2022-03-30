FactoryBot.define do
  factory :live_stream, class: BxBlockContentmanagement::LiveStream do
  	# tag { Faker::Alphanumeric.unique.alphanumeric(7) }
    headline { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(7) }
    url { Faker::Alphanumeric.unique.alphanumeric(20) }
    # scheduling_live_streaming { DateTime.now }
    # publishing_date_and_time {Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default)}
  end
end
