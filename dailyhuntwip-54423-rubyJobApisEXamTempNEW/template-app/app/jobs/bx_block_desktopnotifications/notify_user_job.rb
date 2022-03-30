module BxBlockDesktopnotifications
  class NotifyUserJob < ApplicationJob
    queue_as :default

    def perform(option,registration_ids)
      BxBlockPushNotifications::DesktopNotification.desktop_notify(option,[registration_ids.first])
      BxBlockPushNotifications::MobileNotification.mobile_notify(option,[registration_ids.last])
    end
  end
end