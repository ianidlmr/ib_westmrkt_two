# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  include SendGrid

  def test_email(email)
    template_id = '9cea8aa4-3f72-4c66-934a-44741456c367'
    substitutions = { '-environment-': Rails.env }

    sendgrid_send to: email, subject: 'Test email from Railway', substitutions: substitutions, template_id: template_id
  end

  # rubocop:disable Metrics/AbcSize
  def sendgrid_send(options = {})
    return if Rails.env.test?
    return unless Rails.application.secrets[:send_email].to_b

    options.reverse_merge! to: Figaro.env.override_send_to_email,
                           subject:  %w(development integration).include?(Rails.env) ? "[#{Rails.env}]" : ' ',
                           substitutions: {}

    # A personlization object can have substitutions
    personalization = Personalization.new

    options[:substitutions].each do |k, v|
      personalization.substitutions = Substitution.new(key: k.to_s, value: v)
    end

    # Always use the override_send_to_email if it exists
    personalization.to = if Figaro.env.override_send_to_email.present?
                           Email.new(email: Figaro.env.override_send_to_email)
                         else
                           Email.new(email: options[:to])
                         end

    # Setup the Mail object
    mail = Mail.new

    # Build up Mail paramters and add personalizations with templates
    mail.from = Email.new(email: Rails.application.secrets[:sendgrid_from_email], name: Rails.application.secrets[:sendgrid_from_name])
    mail.subject = options[:subject]
    mail.contents = Content.new(type: 'text/html', value: '<br/>') # A non-empty string needs to be here
    mail.personalizations = personalization
    mail.template_id = options[:template_id]

    # Setup the mailer
    mailer = SendGrid::API.new(api_key: Figaro.env.sendgrid_api_key)

    # Setup the logger
    logger = Logger.new('log/emails.log')

    # Send the email
    response = send_it(mailer, mail)

    # Log emails
    logger.info("To Email: #{options[:to]}, Template ID: #{options[:template_id]}, Status Code: #{response&.status_code}, Status Message: #{response&.body}")
  end
  # rubocop:enable Metrics/AbcSize

  private

  def send_it(mailer, mail)
    mailer.client.mail._('send').post(request_body: mail.to_json)
  end
end
