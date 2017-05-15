# frozen_string_literal: true
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    unless request.path_info == '/users/sign_in'
      user = User.find_by email: params[:user][:email]
      if user.nil? || !user.valid_password?(params[:user][:password])
        render text: 'Invalid Email or Password', status: 422
      else
        super
      end
    end
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
