# frozen_string_literal: true
class Api::V1::Stripe::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :protect

  # This user/password is added to the webhook URLs in the Stripe settings to ensure we are getting authenticated webhooks directly from Stripe only.
  # http_basic_authenticate_with(name: Figaro.env.api_http_auth_name, password: Figaro.env.api_http_auth_password) unless Rails.env.production?

  # def protect
  #   @ips = ['54.187.174.169', '54.187.205.235', '54.187.216.72', '54.241.31.99', '54.241.31.102', '54.241.34.107']
  #   return unless @ips.include? request.remote_ip
  #   render text: 'You are unauthorized'
  # end
end
