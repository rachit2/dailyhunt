require "rails_helper"

RSpec.describe BxBlockDesktopnotifications::NotifyToCompleteProfileJob, :type => :job do
  let!(:account1){ FactoryBot.create(:account, desktop_device_id: '69439b981f40459f8a8a21a0092a9b62', device_id: '69439b981f40459f8a8a21a0092adgf', city: '' )}
  let!(:account2){ FactoryBot.create(:account, desktop_device_id: '69439b981f40459f8a8a21a0092a9b63', device_id: '69439b981f40459f8a8a21a0092adgh', city: 'vancover' )}
  let!(:account3){ FactoryBot.create(:account, desktop_device_id: '69439b981f40459f8a8a21a0092a9b64', device_id: '69439b981f40459f8a8a21a0092adgi', city: nil )}
  
  before :each do
    BxBlockLanguageoptions::BuildLanguages.call
    BxBlockLanguageoptions::CreateAndUpdateTranslations.call
    BxBlockLanguageoptions::SetAvailableLocales.call

    BxBlockLanguageoptions::ApplicationMessage.set_message_for("notifications.complete_profile.title", "hi", "Careerhunt in hindi")
    BxBlockLanguageoptions::ApplicationMessage.set_message_for("notifications.complete_profile.body", "hi", "Complete Your Profile in hindi")
    hi_language = BxBlockLanguageoptions::Language.find_by(language_code: 'hi')
    hi_language.update(is_app_language: true)
    account3.update(app_language: hi_language)
  end

  let(:options) do
    {
      :notification => 
      {
        :title  => 'Careerhunt',
        :body => 'Complete Your Profile',
      },
      :data =>
      {
        :notification_type => "CompleteProfile"
      }
    }
  end

  let(:hi_options) do
    {
      :notification => 
      {
        :title  => 'Careerhunt in hindi',
        :body => 'Complete Your Profile in hindi',
      },
      :data =>
      {
        :notification_type => "CompleteProfile"
      }
    }
  end

  describe "#perform_later" do
    it "should send notification to user for desktop user" do
      expect(BxBlockPushNotifications::DesktopNotification).to receive(:desktop_notify).with(options, [account1.desktop_device_id]).and_return(options)
      expect(BxBlockPushNotifications::MobileNotification).to receive(:mobile_notify).with(options, [account1.device_id])
      expect(BxBlockPushNotifications::MobileNotification).not_to receive(:mobile_notify).with(options, [account2.device_id])
      expect(BxBlockPushNotifications::DesktopNotification).not_to receive(:desktop_notify).with(options, [account2.desktop_device_id])
      expect(BxBlockPushNotifications::DesktopNotification).to receive(:desktop_notify).with(hi_options, [account3.desktop_device_id])
      expect(BxBlockPushNotifications::MobileNotification).to receive(:mobile_notify).with(hi_options, [account3.device_id])
      BxBlockDesktopnotifications::NotifyToCompleteProfileJob.perform_now
    end
  end
end
