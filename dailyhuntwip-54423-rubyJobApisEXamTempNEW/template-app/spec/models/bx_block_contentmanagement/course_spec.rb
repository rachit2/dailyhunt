# == Schema Information
#
# Table name: courses
#
#  id                                 :bigint           not null, primary key
#  description                        :text
#  heading                            :string
#  is_popular                         :boolean          default(FALSE)
#  is_premium                         :boolean          default(FALSE)
#  is_trending                        :boolean          default(FALSE)
#  price                              :integer
#  rank                               :integer
#  thumbnail                          :string
#  video                              :string
#  what_you_will_learn_in_this_course :text
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  category_id                        :bigint
#  content_provider_id                :bigint
#  language_id                        :bigint
#  sub_category_id                    :bigint
#
# Indexes
#
#  index_courses_on_category_id          (category_id)
#  index_courses_on_content_provider_id  (content_provider_id)
#  index_courses_on_language_id          (language_id)
#  index_courses_on_sub_category_id      (sub_category_id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Course, type: :model do
  describe 'associations' do
    it { should belong_to(:category).class_name('BxBlockCategories::Category') }
    it { should belong_to(:sub_category).class_name('BxBlockCategories::SubCategory') }
  end
end
