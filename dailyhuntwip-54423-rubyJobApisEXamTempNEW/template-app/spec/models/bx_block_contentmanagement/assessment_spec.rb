# == Schema Information
#
# Table name: assessments
#
#  id                  :bigint           not null, primary key
#  description         :text
#  heading             :string
#  is_popular          :boolean
#  is_trending         :boolean
#  timer               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  category_id         :bigint
#  content_provider_id :integer
#  language_id         :bigint           not null
#  sub_category_id     :bigint
#
# Indexes
#
#  index_assessments_on_category_id      (category_id)
#  index_assessments_on_language_id      (language_id)
#  index_assessments_on_sub_category_id  (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
require 'rails_helper'
RSpec.describe BxBlockContentmanagement::Assessment, type: :model do

  describe 'associations' do
    it { should belong_to(:language).class_name('BxBlockLanguageoptions::Language') }
    it { should belong_to(:content_provider).class_name('BxBlockAdmin::AdminUser') }
    it { should have_many(:test_questions).class_name('BxBlockContentmanagement::TestQuestion').dependent(:destroy) }
    it { should belong_to(:category).class_name('BxBlockCategories::Category') }
    it { should belong_to(:sub_category).class_name('BxBlockCategories::SubCategory') }
  end

  describe 'validations' do
    it { should validate_presence_of(:heading) }
    it { should validate_presence_of(:description) }
  end
end
