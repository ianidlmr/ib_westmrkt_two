# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_liked_units

  def get_liked_units
    @liked_units = current_user&.liked_units
  end
end
