require 'rails_helper'

RSpec.describe BxBlockPushNotifications::FirebaseNotifier, type: :services do

  let(:account){ FactoryBot.create(:account, device_id: '69439b981f40459f8a8a21a0092a9b62')}
  let(:options) do
    {
      :notification => 
      {
        :title  => 'Careerhunt',
        :body => "Hi, Please Visit App",
      },
      :data =>
      {
        :notification_type => "IdleUser"
      }
    }
  end

  context 'Send Notification' do
    
    it 'should return status 200' do
      client = FCM.new(Rails.application.secrets.fcm_server_key)
      expect(FCM).to receive(:new).with(Rails.application.secrets.fcm_server_key).and_return(client)
      BxBlockPushNotifications::FirebaseNotifier.send(options,[account.device_id])
    end
  end
end
