# frozen_string_literal: true
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    proceed_with_authorization request.env['omniauth.auth']
  end

  def proceed_with_authorization(auth)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.titleize) if is_navigational_format?
    else
      redirect_to new_user_registration_path
    end
  end
end
