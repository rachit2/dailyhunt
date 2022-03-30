module BxBlockPushNotifications
  class DesktopNotification
    def self.desktop_notify(options,registration_ids)
      BxBlockPushNotifications::FirebaseNotifier.send(options,registration_ids)
    end
  end
end