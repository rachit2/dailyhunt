# == Schema Information
#
# Table name: categories
#
#  id                  :bigint           not null, primary key
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  admin_user_id       :integer
#  rank                :integer
#  light_icon          :string
#  light_icon_active   :string
#  light_icon_inactive :string
#  dark_icon           :string
#  dark_icon_active    :string
#  dark_icon_inactive  :string
#  identifier          :integer
#
require 'rails_helper'

RSpec.describe BxBlockCategories::Category, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:sub_categories).join_table(:categories_sub_categories).dependent(:destroy) }
    it { should have_many(:contents).class_name('BxBlockContentmanagement::Content').dependent(:destroy)}
    it { should have_many(:user_categories).class_name('BxBlockCategories::UserCategory').join_table(:user_categoeries).dependent(:destroy)}
    it { should have_and_belong_to_many(:partners).class_name('BxBlockRolesPermissions::Partner').join_table(:categories_partners).dependent(:destroy) }
    it { should belong_to(:admin_user).class_name('BxBlockAdmin::AdminUser').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name)}
  end
end
