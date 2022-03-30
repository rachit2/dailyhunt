require 'rails_helper'

RSpec.describe BxBlockPushNotifications::DesktopNotification, type: :services do

  let(:account){ FactoryBot.create(:account, desktop_device_id: '69439b981f40459f8a8a21a0092a9b62')}
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

  context 'Send Desktop Notification' do
    
    it 'should send desktop notification' do
      expect(BxBlockPushNotifications::FirebaseNotifier).to receive(:send).with(options, [account.desktop_device_id])
      BxBlockPushNotifications::DesktopNotification.desktop_notify(options, [account.desktop_device_id])
    end
  end
end
