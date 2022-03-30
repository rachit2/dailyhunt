# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BxBlockRolesPermissions::Role, type: :model do
  describe 'associations' do
    it { should have_many(:accounts).class_name('AccountBlock::Account').dependent(:destroy) }
    it { should have_many(:admin_user_roles).class_name('BxBlockAdmin::AdminUserRole').dependent(:destroy) }
    it { should have_many(:admin_users).through(:admin_user_roles).class_name('BxBlockAdmin::AdminUser')}
    it { should define_enum_for(:name).with_values(super_admin: 'super_admin', partner: 'partner', operations_l2: 'operations_l2', operations_l1: 'operations_l1', finance: 'finance', sales_and_marketing: 'sales_and_marketing', content: 'content', ad_hoc: 'ad_hoc').backed_by_column_of_type(:string) }
  end
end
