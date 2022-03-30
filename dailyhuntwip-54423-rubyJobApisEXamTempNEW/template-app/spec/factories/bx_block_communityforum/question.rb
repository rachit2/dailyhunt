FactoryBot.define do
  factory :question, class: BxBlockCommunityforum::Question do
    title { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
    account
    sub_category
    status { 1 }
    closed { false }
    image { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark.png").open }
  end
end
