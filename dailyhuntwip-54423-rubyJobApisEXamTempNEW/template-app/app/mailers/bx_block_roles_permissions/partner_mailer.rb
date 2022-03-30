module BxBlockRolesPermissions
  class PartnerMailer < ApplicationMailer

    def welcome_email(admin_user_id, partner_name)
      @admin_user = BxBlockAdmin::AdminUser.find(admin_user_id)
      @partner_name = partner_name
      @url = Rails.application.routes.url_helpers.new_admin_user_session_url(host: ENV['APPURL'])
      @password = @admin_user.set_random_password
      @admin_user.save
      mail(to: @admin_user.email, subject: 'Credential For Login')
    end

    def decline_email(admin_user_email)
      @url = Rails.application.routes.url_helpers.new_bx_block_roles_permissions_partner_url(host: ENV['APPURL'])
      mail(to: admin_user_email, subject: 'Registeration Decline')
    end

    def send_email_l1_and_l2(partner_id, l1_or_l2_user_email)
      @partner = BxBlockRolesPermissions::Partner.find_by(id: partner_id)
      @l1_or_l2_user_email = l1_or_l2_user_email
      mail(to: l1_or_l2_user_email, subject: 'New Partner Signup')
    end
  end
end
