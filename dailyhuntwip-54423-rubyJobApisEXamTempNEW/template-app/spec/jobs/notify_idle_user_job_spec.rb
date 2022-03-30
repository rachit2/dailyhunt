require "rails_helper"

RSpec.describe BxBlockDesktopnotifications::NotifyIdleUserJob, :type => :job do
  let!(:account1){ FactoryBot.create(:account, desktop_device_id: '69439b981f40459f8a8a21a0092a9b62', device_id: '69439b981f40459f8a8a21a0092adgf', last_visit_at: DateTime.now - 2 )}
  let!(:account2){ FactoryBot.create(:account, desktop_device_id: '69439b981f40459f8a8a21a0092a9b63', device_id: '69439b981f40459f8a8a21a0092adgg')}
  let!(:account3){ FactoryBot.create(:account, desktop_device_id: '69439b981f40459f8a8a21a0092a9b64', device_id: '69439b981f40459f8a8a21a0092adgh', last_visit_at: DateTime.now - 2)}
  
  before :each do
    BxBlockLanguageoptions::BuildLanguages.call
    BxBlockLanguageoptions::CreateAndUpdateTranslations.call
    BxBlockLanguageoptions::SetAvailableLocales.call

    BxBlockLanguageoptions::ApplicationMessage.set_message_for("notifications.idle_user.title", "hi", "Careerhunt in hindi")
    BxBlockLanguageoptions::ApplicationMessage.set_message_for("notifications.idle_user.body", "hi", "Hi, Please Visit App in hindi")
    hi_language = BxBlockLanguageoptions::Language.find_by(language_code: 'hi')
    hi_language.update(is_app_language: true)
    account3.update(app_language: hi_language)
  end

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

  let(:options_hi) do
    {
      :notification => 
      {
        :title  => "Careerhunt in hindi",
        :body => "Hi, Please Visit App in hindi",
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
      expect(BxBlockPushNotifications::MobileNotification).not_to receive(:mobile_notify).with(options, [account2.device_id])
      expect(BxBlockPushNotifications::DesktopNotification).not_to receive(:desktop_notify).with(options, [account2.desktop_device_id])
      expect(BxBlockPushNotifications::MobileNotification).to receive(:mobile_notify).with(options_hi, [account3.device_id])
      expect(BxBlockPushNotifications::DesktopNotification).to receive(:desktop_notify).with(options_hi, [account3.desktop_device_id])
      
      BxBlockDesktopnotifications::NotifyIdleUserJob.perform_now
    end
  end
end
