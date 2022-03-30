module BxBlockContentmanagement
  class ContentMailer < ApplicationMailer

    def send_email_l2(l1_id, l2_user_email, content_id)
      @l1_user = BxBlockAdmin::AdminUser.find_by(id: l1_id)
      @l2_user_email = l2_user_email
      @content = BxBlockContentmanagement::Content.find_by(id: content_id)
      @url = "#{ENV['APPURL']}/admin/bx_block_contentmanagement~content/#{content_id}"
      mail(to: l2_user_email, subject: 'L1 submit to review email')
    end

    def send_email_l1(l2_id, l1_user_email, review_status, content_name)
      @l2_user = BxBlockAdmin::AdminUser.find_by(id: l2_id)
      @l1_user_email = l1_user_email
      @review_status = review_status
      @content_name = content_name
      mail(to: l1_user_email, subject: 'L2 approve and reject email')
    end
  end
end
