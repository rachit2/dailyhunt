module BxBlockPushNotifications
  class EmailNotificationService

    def send(email,subject,msg)
      BxBlockPushNotifications::EmailNotificationMailer.with(email_address: email,subject: subject,email_body: msg).send_email_notification.deliver
    end  
  end
end