FactoryBot.define do
  factory :admin_user_role, class: BxBlockAdmin::AdminUserRole do
    admin_user
    role
  end
end
