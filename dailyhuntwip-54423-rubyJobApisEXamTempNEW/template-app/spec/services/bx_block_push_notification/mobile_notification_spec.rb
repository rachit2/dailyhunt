require 'rails_helper'

RSpec.describe BxBlockPushNotifications::MobileNotification, type: :services do

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
    it 'should send mobile notification' do
      expect(BxBlockPushNotifications::FirebaseNotifier).to receive(:send).with(options, [account.device_id])
      BxBlockPushNotifications::MobileNotification.mobile_notify(options,[account.device_id])
    end
  end
end
