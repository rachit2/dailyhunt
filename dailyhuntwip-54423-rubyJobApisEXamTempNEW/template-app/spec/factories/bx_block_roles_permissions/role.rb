FactoryBot.define do
  factory :role, class: BxBlockRolesPermissions::Role do
    name { 'super_admin' }
  end
end
