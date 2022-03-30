require 'rails_helper'
require "cancan/matchers"

RSpec.describe "Ability" do

  subject(:ability){ Ability.new(user) }

  context "when is an admin user super_admin" do
    let(:role){FactoryBot.create(:role, name:"super_admin")}
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
    let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}
    it{ should be_able_to(:manage, :all) }
    it{ should_not be_able_to(:destroy, BxBlockContentmanagement::Author.new) }
    it{ should_not be_able_to(:destroy, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:edit, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:create, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:destroy, AccountBlock::Account.new) }
    it{ should_not be_able_to(:edit, AccountBlock::Account.new) }
    it{ should_not be_able_to(:create, AccountBlock::Account.new) }
  end

  context "when is an admin user partner" do
    let(:role){FactoryBot.create(:role, name:"partner")}
    let(:partner){ FactoryBot.build(:partner) }
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role, partner: partner) }

    let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

    it{ should be_able_to(:manage, BxBlockContentmanagement::Content.new) }
    it{ should be_able_to(:read, BxBlockCategories::Category) }
    it{ should be_able_to(:read, BxBlockCategories::SubCategory) }
    it{ should be_able_to(:read, BxBlockLanguageoptions::Language.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::ContentType) }
    it{ should be_able_to(:read, BxBlockContentmanagement::AudioPodcast.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::ContentText.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::ContentVideo.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::LiveStream.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::Author.new) }
    it{ should_not be_able_to(:manage, BxBlockCategories::Category.new) }
    it{ should_not be_able_to(:destroy, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:edit, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:create, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:destroy, AccountBlock::Account.new) }
    it{ should_not be_able_to(:edit, AccountBlock::Account.new) }
    it{ should_not be_able_to(:create, AccountBlock::Account.new) }
  end

  context "when is an admin user operations_l2" do
    let(:role){FactoryBot.create(:role, name:"operations_l2")}
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
    let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

    it{ should be_able_to(:manage, BxBlockCategories::SubCategory.new) }
    it{ should be_able_to(:manage, BxBlockCategories::Category.new) }
    it{ should be_able_to(:manage, BxBlockContentmanagement::Content.new) }
    it{ should be_able_to(:manage, BxBlockAdmin::AdminUserRole.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::Author.new) }
    it{ should be_able_to(:manage, BxBlockContentmanagement::Content.new) }
    it{ should be_able_to(:read, BxBlockLanguageoptions::Language.new) }
    it{ should be_able_to(:manage, BxBlockContentmanagement::ContentType.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::AudioPodcast.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::ContentText.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::ContentVideo.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::LiveStream.new) }
    it{ should_not be_able_to(:destroy, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:edit, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:create, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:destroy, AccountBlock::Account.new) }
    it{ should_not be_able_to(:edit, AccountBlock::Account.new) }
    it{ should_not be_able_to(:create, AccountBlock::Account.new) }
  end

  context "when is an admin user operations_l1" do
    let(:role){FactoryBot.create(:role, name:"operations_l1")}
    let(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role) }
    let(:admin_user_role){FactoryBot.create(:admin_user_role, admin_user: user, role: role)}

    it{ should be_able_to(:manage, BxBlockContentmanagement::ContentType.new) }
    it{ should be_able_to(:manage, BxBlockContentmanagement::Content.new) }
    it{ should be_able_to(:manage, BxBlockAdmin::AdminUserRole.new) }
    it{ should be_able_to(:read, BxBlockCategories::Category.new) }
    it{ should be_able_to(:read, BxBlockCategories::SubCategory.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::ContentType.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::AudioPodcast.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::ContentText.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::ContentVideo.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::LiveStream.new) }
    it{ should be_able_to(:read, BxBlockContentmanagement::Author.new) }
    it{ should_not be_able_to(:manage, BxBlockCategories::Category.new) }
    it{ should_not be_able_to(:destroy, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:edit, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:create, BxBlockRolesPermissions::Partner.new) }
    it{ should_not be_able_to(:destroy, AccountBlock::Account.new) }
    it{ should_not be_able_to(:edit, AccountBlock::Account.new) }
    it{ should_not be_able_to(:create, AccountBlock::Account.new) }
  end

end
