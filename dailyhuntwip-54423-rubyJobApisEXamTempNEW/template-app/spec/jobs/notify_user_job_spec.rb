require "rails_helper"

RSpec.describe BxBlockDesktopnotifications::NotifyUserJob, :type => :job do

  let(:account1){ FactoryBot.create(:account, desktop_device_id: '69439b981f40459f8a8a21a0092a9b62', device_id: '69439b981f40459f8a8a21a0092adgf' )}
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

  describe "#perform_later" do
    it "should send notification to user" do
      expect(BxBlockPushNotifications::DesktopNotification).to receive(:desktop_notify).with(options, [account1.desktop_device_id]).and_return(options)
      expect(BxBlockPushNotifications::MobileNotification).to receive(:mobile_notify).with(options, [account1.device_id])
      BxBlockDesktopnotifications::NotifyUserJob.perform_now(options, [account1.desktop_device_id, account1.device_id])
    end
  end
end
