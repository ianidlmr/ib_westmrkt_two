# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :liked_unit_groups

  # TODO: Remove before public launch
  if Rails.env.production? || Rails.env.integration?
    http_basic_authenticate_with name: 'railway', password: 'railwaydevbbq' # keeping the same credentials as integration server
  end

  def liked_unit_groups
    if user_signed_in?
      @liked_unit_groups = Like.includes(unit: [:unit_type]).where(user: current_user).sort_by { |liked_unit| liked_unit.unit.unit_type.name }.group_by { |liked_unit| { name: liked_unit.unit.unit_type.name, state: liked_unit.unit.state } }
      @liked_units_count = current_user.likes.size
    end
  end
end
