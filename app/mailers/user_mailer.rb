# frozen_string_literal: true
class UserMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def confirmation_instructions(record, token, _opts = {})
    options = {
      to: record.email,
      subject: 'Welcome to Railway',
      template_id: 'f025ac9f-bcd3-41d7-a46a-fe8c43e3f27a',
      substitutions: {
        '-url-': confirmation_url(record, confirmation_token: token)
      }
    }

    sendgrid_send options
  end

  def reset_password_instructions(record, token, _opts = {})
    options = {
      to: record.email,
      subject: 'Please reset your Railway password',
      template_id: 'daee5565-162a-487c-b7ae-6f76979e90aa',
      substitutions: {
        '-url-': edit_user_password_url(record, reset_password_token: token)
      }
    }
    sendgrid_send options
  end
end
