# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_liked_unit_groups

  def get_liked_unit_groups
    if user_signed_in?
      @liked_unit_groups = current_user.liked_units.sort_by{ |liked_unit| liked_unit.unit.unit_type.name }.group_by{ |liked_unit| { name: liked_unit.unit.unit_type.name, state: liked_unit.unit.state } }
      @liked_units_count = current_user.liked_units.count
    end
  end
end
