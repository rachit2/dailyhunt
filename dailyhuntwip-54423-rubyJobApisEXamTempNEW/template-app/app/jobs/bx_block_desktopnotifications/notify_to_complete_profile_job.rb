module BxBlockDesktopnotifications
  class NotifyToCompleteProfileJob < ApplicationJob
    queue_as :default

    def perform
      AccountBlock::Account.where(city: [nil, ""]).find_each do |account|
        lang = account.app_language&.language_code || I18n.default_locale
        Globalize.with_locale(lang) do
          BxBlockPushNotifications::DesktopNotification.desktop_notify(options,[account.desktop_device_id])
          BxBlockPushNotifications::MobileNotification.mobile_notify(options,[account.device_id])
        end
      end
    end

    private
    def options
      { 
        notification: {
          title: BxBlockLanguageoptions::ApplicationMessage.translation_message("notifications.complete_profile.title"),
          body: BxBlockLanguageoptions::ApplicationMessage.translation_message("notifications.complete_profile.body"),
        },
        data: {
          notification_type: "CompleteProfile"
        }
      }
    end
  end
end