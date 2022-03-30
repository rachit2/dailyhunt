# == Schema Information
#
# Table name: admin_user_roles
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  admin_user_id :bigint           not null
#  role_id       :bigint           not null
#
# Indexes
#
#  index_admin_user_roles_on_admin_user_id  (admin_user_id)
#  index_admin_user_roles_on_role_id        (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_user_id => admin_users.id)
#  fk_rails_...  (role_id => roles.id)
#
require 'rails_helper'

RSpec.describe BxBlockAdmin::AdminUserRole, type: :model do
  describe 'associations' do
    it { should belong_to(:admin_user).class_name('BxBlockAdmin::AdminUser') }
    it { should belong_to(:role).class_name('BxBlockRolesPermissions::Role') }
  end
end
