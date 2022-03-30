# == Schema Information
#
# Table name: accounts
#
#  id                :bigint           not null, primary key
#  first_name        :string
#  last_name         :string
#  full_phone_number :string
#  country_code      :integer
#  phone_number      :bigint
#  email             :string
#  activated         :boolean          default(FALSE), not null
#  device_id         :string
#  unique_auth_id    :text
#  password_digest   :string
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_name         :string
#  role_id           :integer
#  city              :string
#  app_language_id   :integer
#  last_visit_at     :datetime
#  desktop_device_id :string
#  dob               :date
#  gender            :integer
#
require 'rails_helper'

RSpec.describe AccountBlock::Account, type: :model do
  describe 'associations' do
    it { should belong_to(:app_language).class_name('BxBlockLanguageoptions::Language').optional }
    it { should have_one(:course_cart).class_name('BxBlockContentmanagement::CourseCart').dependent(:destroy) }
    it { should have_many(:contents_languages).class_name('BxBlockLanguageoptions::ContentLanguage').dependent(:destroy) }
    it { should have_many(:languages).class_name('BxBlockLanguageoptions::Language').through(:contents_languages) }
    it { should have_many(:user_sub_categories).class_name('BxBlockCategories::UserSubCategory').dependent(:destroy) }
    it { should have_many(:sub_categories).class_name('BxBlockCategories::SubCategory').through(:user_sub_categories) }
    it { should have_many(:followers).class_name('BxBlockContentmanagement::Follow') }
    it { should have_many(:content_followings).class_name('BxBlockContentmanagement::Content').through(:bookmarks) }
  end
end
