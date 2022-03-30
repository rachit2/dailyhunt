# == Schema Information
#
# Table name: application_configs
#
#  id                    :bigint           not null, primary key
#  mime_type             :string
#  status                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  home_page_description :text
#
require 'rails_helper'

RSpec.describe BxBlockLogin::ApplicationConfig, type: :model do
  describe 'associations' do
    it { should have_one(:login_background_file).class_name('LoginBackgroundFile').dependent(:destroy) }
    it{ should accept_nested_attributes_for(:login_background_file).allow_destroy(true) }
  end

  describe "validations" do
    it { should validate_presence_of(:login_background_file) }
  end

  describe "scope active" do
    let(:background_file) {  fixture_file_upload(Rails.root.join('spec', 'fixtures', 'short.mov'), 'video/mov') }
    let!(:application_config_active) { FactoryBot.create(:application_config, login_background_file_attributes: { login_background_file: background_file })}
    let!(:application_config_not_active) { FactoryBot.create(:application_config, status: "inactive", login_background_file_attributes: { login_background_file: background_file })}
      
    it "includes application config with active true" do
      expect(BxBlockLogin::ApplicationConfig.active).to include(application_config_active)
    end

    it "excludes application config with active true" do
      expect(BxBlockLogin::ApplicationConfig.active).not_to include(application_config_not_active)
    end
  end
end
