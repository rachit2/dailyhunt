# == Schema Information
#
# Table name: sub_categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#  rank       :integer
#
require 'rails_helper'

RSpec.describe BxBlockCategories::SubCategory, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:categories).join_table(:categories_sub_categories).dependent(:destroy) }
    it { should belong_to(:parent).class_name('BxBlockCategories::SubCategory').optional }
    it { should have_many(:sub_categories).class_name('BxBlockCategories::SubCategory').dependent(:destroy)}
    it { should have_many(:user_sub_categories).class_name('BxBlockCategories::UserSubCategory').join_table(:user_sub_categoeries).dependent(:destroy)}
    it { should have_many(:accounts).class_name('AccountBlock::Account').through(:user_sub_categories).join_table(:user_sub_categoeries)}
    it { should have_many(:contents).class_name('BxBlockContentmanagement::Content').dependent(:destroy) }
    it { should have_and_belong_to_many(:partners).class_name('BxBlockRolesPermissions::Partner').join_table(:partners_sub_categories).dependent(:destroy) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name)}
  end
end
