# == Schema Information
#
# Table name: specializations
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  rank                      :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  degree_id                 :bigint
#  higher_education_level_id :bigint
#
FactoryBot.define do
  factory :specialization, class: BxBlockProfile::Specialization do
    name { Faker::Alphanumeric.unique.alphanumeric(7)  }
    rank { 1 }
    degree
    association :higher_education_level, factory: :education_level
  end
end
