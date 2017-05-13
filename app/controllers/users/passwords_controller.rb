# frozen_string_literal: true
class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    super do
      user = User.find_by email: params[:user][:email]
      render(json: 'Invalid Email', status: 422) && return if user.nil?
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(_resource_name)
    root_path
  end
end
