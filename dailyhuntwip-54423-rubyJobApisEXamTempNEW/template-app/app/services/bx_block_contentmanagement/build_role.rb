module BxBlockContentmanagement
  module BuildRole
    class << self

      def call(roles = role_array)
        roles.each do |role1|
          BxBlockRolesPermissions::Role.where('name = ?', role1).first_or_create(:name=>role1)
        end

        orphan_admin_users = BxBlockAdmin::AdminUser.left_outer_joins(:role).where(roles: {id: nil})
        role = BxBlockRolesPermissions::Role.find_by(name: "super_admin")
        orphan_admin_users.update(role: role)
      end

      private

      def role_array
        BxBlockRolesPermissions::Role.names.keys
      end
    end
  end
end
