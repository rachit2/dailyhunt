module BxBlockPushNotifications
  class FirebaseNotifier

    def self.send(options, registration_ids = [])
      registration_ids = registration_ids.flatten
      client = FCM.new( ENV['FCM_SERVER_KEY'])
      begin
        response = client.send(registration_ids, options)
        detail = { status: true }
      rescue Exception => e
        detail = { status: false, detail: e.message }
      end
      detail
    end
  end
end
