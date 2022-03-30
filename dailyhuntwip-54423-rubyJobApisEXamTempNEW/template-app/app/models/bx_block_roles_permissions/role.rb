# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockRolesPermissions
  class Role < ApplicationRecord
    self.table_name = :roles

    ROLE_MAPPINGS = {
        "content" => "Content",
        "partner" => "Partner",
        "operations_l2" => "L2",
        "operations_l1" => "L1",
        "finance" => "Finance",
        "sales_and_marketing" => "Sales_And_Marketing",
        "ad_hoc" => "Ad_Hoc",
        "super_admin" => "Super_Admin"
    }.freeze

    has_many :accounts, class_name: 'AccountBlock::Account', dependent: :destroy
    has_many :admin_user_roles, class_name: 'BxBlockAdmin::AdminUserRole', dependent: :destroy
    has_many :admin_users, through: :admin_user_roles, class_name: 'BxBlockAdmin::AdminUser'

    scope :operation_l2_role, -> { where(name: ["partner", "operations_l1"]) }
    scope :operation_l1_role, -> { where(name: ["partner"]) }

    validates :name, uniqueness: { message: 'Role already present' }

    enum name: { super_admin: 'super_admin', partner: 'partner', operations_l2: 'operations_l2', operations_l1: 'operations_l1', finance: 'finance', sales_and_marketing: 'sales_and_marketing', content: 'content', ad_hoc: 'ad_hoc' }

    def name
      ROLE_MAPPINGS[super]
    end
  end
end
