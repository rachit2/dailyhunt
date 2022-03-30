require 'rails_helper'

RSpec.describe "Seeds" do

  describe "check initial categories and sub categories" do
    let(:category_name) { 'K12' }
    let(:sub_category_name) { 'Pre Primary (kg)' }

    context 'Seed for categories and sub categories' do
      it 'should create categories and sub_categories with correct categories and sub_categories' do
        expect(BxBlockCategories::Category.count).to eq(0)
        expect(BxBlockCategories::SubCategory.count).to eq(0)

        load Rails.root + "db/seeds.rb"

        expected_category = BxBlockCategories::Category.find_by_name(category_name)
        expected_sub_category = BxBlockCategories::SubCategory.find_by_name(sub_category_name)
        expect(expected_category).to be_present
        expect(expected_sub_category).to be_present
      end
    end
  end

  describe "check initial language" do
    let(:name) { 'Hindi' }
    let(:language_code) { 'hi' }

    context 'Seed for language' do
      it 'should create language with correct language and its language code' do
        expect(BxBlockLanguageoptions::Language.count).to eq(0)

        load Rails.root + "db/seeds.rb"

        expected_language = BxBlockLanguageoptions::Language.find_by(name: name, language_code: language_code)
        expect(expected_language).to be_present
      end
    end
  end

  describe "check initial content type" do
    let(:name) { 'News Articles' }
    let(:type) { 'Text' }

    context 'Seed for content type' do
      it 'should create content type with correct name and type' do
        expect(BxBlockContentmanagement::ContentType.count).to eq(0)

        load Rails.root + "db/seeds.rb"

        expected_content_type = BxBlockContentmanagement::ContentType.find_by(name: name, type: type)
        expect(expected_content_type).to be_present
      end
    end
  end

  describe "check initial roles" do
    let(:roles) { BxBlockRolesPermissions::Role::ROLE_MAPPINGS.values }

    context 'Seed for content type' do
      it 'should create content type with correct name and type' do
        expect(BxBlockRolesPermissions::Role.count).to eq(0)

        load Rails.root + "db/seeds.rb"

        all_roles = BxBlockRolesPermissions::Role.all.map {|role| role.name}
        expect(roles).to match_array(all_roles)
      end
    end
  end

  describe "check initial admin user" do
    let(:email) { 'admin@careerhunt.com' }

    context 'Seed admin user' do
      it 'should create super admin user with correct role and email' do
        expect(BxBlockAdmin::AdminUser.count).to eq(0)

        expect{
          load Rails.root + "db/seeds.rb"
        }.to change{ BxBlockAdmin::AdminUser.count }.by(1)

        admin = BxBlockAdmin::AdminUser.find_by_email(email)
        expect(admin).to be_present
        expect(admin.super_admin?).to eq(true)
      end
    end
  end
end
