module BxBlockPushNotifications
  class EmailNotificationMailer < ApplicationMailer

    def send_email_notification
      @email_body = params[:email_body]
      subject = params[:subject]
      email = params[:email_address]
      mail(to: email, subject: subject)
    end
  end
end

