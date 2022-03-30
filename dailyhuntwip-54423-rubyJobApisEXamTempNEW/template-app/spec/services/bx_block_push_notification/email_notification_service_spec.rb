require 'rails_helper'

RSpec.describe BxBlockPushNotifications::EmailNotificationService, type: :services do

  let(:email){ "xyz.ad@gmail.com"}
  let(:subject) {"Email notification test"}
  let(:msg) {"This is testing of email notification service"}

  context 'Send Notification' do
    
    it 'should return subject as expected' do
      mail_resp = BxBlockPushNotifications::EmailNotificationMailer.with(email_address: email,subject: subject,email_body: msg).send_email_notification.deliver
      expect(mail_resp.subject).to eq (subject)
    end

    it 'should return email as expected' do
      mail_resp = BxBlockPushNotifications::EmailNotificationMailer.with(email_address: email,subject: subject,email_body: msg).send_email_notification.deliver
      expect(mail_resp.to[0]).to eq (email)
    end

    it 'should perform email delivery correctly for welcome mail' do
      expect {
        BxBlockPushNotifications::EmailNotificationMailer.with(email_address: email,subject: subject,email_body: msg).send_email_notification.deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
