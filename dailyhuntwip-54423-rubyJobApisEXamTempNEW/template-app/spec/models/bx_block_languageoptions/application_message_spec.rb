# == Schema Information
#
# Table name: application_messages
#
#  id                     :bigint           not null, primary key
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  application_message_id :bigint           not null
#  message                :text             not null
#
require 'rails_helper'

RSpec.describe BxBlockLanguageoptions::ApplicationMessage, type: :model do
    describe 'model validations' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }
      let!(:application_message) { FactoryBot.create(:application_message) }
      
      it 'should return application message' do
        application_message_obj  = BxBlockLanguageoptions::ApplicationMessage.translation_message(application_message.name)
        expect(application_message_obj).to eq(application_message.message)
      end
      
      it 'should validate en translation message' do
        response_status = BxBlockLanguageoptions::ApplicationMessage.new(name: "gngmn")
        expect(response_status.save).to eq false
        expect(response_status.errors.full_messages.first).to eq "Translations message EN translation message can't be blank"
      end
    end 
end


