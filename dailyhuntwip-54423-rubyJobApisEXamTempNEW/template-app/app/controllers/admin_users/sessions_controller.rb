# frozen_string_literal: true

class AdminUsers::SessionsController < Devise::SessionsController

  # before_action :configure_sign_in_params, only: [:create]
  prepend_before_action :check_current_session, only: [:new, :create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  def create
    resource = BxBlockAdmin::AdminUser.find_for_database_authentication(email: params[:admin_user][:email])
    return invalid_login_attempt unless resource
    if resource.valid_password?(params[:admin_user][:password])
      if resource.partner?
        if resource.partner.present? and resource.partner.approved?
          super
        else
          flash[:danger] = "your status is not approved"
          redirect_to new_admin_user_session_path
        end
      else
        super
      end
    else
      super
    end
  end


  protected

  def check_current_session
    if signed_in?
      flash[:danger] = "Please log out first before you proceed."
      redirect_to root_path
    end
  end

  def invalid_login_attempt
    set_flash_message(:alert, :invalid)
    respond_to do |format|
      format.js { render '/devise/sessions/create' }
      # format.js { render json: flash[:alert], status: 401}
      format.html {redirect_to new_admin_user_session_path}
    end
  end
end
