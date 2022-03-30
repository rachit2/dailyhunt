module BxBlockPushNotifications
  class MobileNotification
    def self.mobile_notify(options,registration_ids)
      BxBlockPushNotifications::FirebaseNotifier.send(options,registration_ids)
    end 
  end
end