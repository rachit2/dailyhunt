# BxBlockAdmin::CreateAdmin.call
module BxBlockAdmin
  class CreateAdmin
    class << self
      def call
        role = BxBlockRolesPermissions::Role.find_by(name: "super_admin")
        BxBlockAdmin::AdminUser.create_with(password: 'careerhunt@321', role: role).find_or_create_by(email: 'admin@careerhunt.com')
      end
    end
  end
end
