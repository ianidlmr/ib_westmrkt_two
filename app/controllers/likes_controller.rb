# frozen_string_literal: true
class LikesController < ApplicationController
  before_action :find_likable_unit, only: [:like_unit, :unlike_unit]

  def like_unit
    current_user.likes.find_or_create_by(unit: @likable_unit) if @likable_unit.present?
    current_user.likes.reload
    @liked_unit_groups = current_user.likes.sort_by{ |liked_unit| liked_unit.unit.unit_type.name }.group_by{ |liked_unit| { name: liked_unit.unit.unit_type.name, state: liked_unit.unit.state } }
    @liked_units_count = current_user.likes.size
  end

  def unlike_unit
    current_user.likes.find_by(unit: @likable_unit).destroy! if @likable_unit.present?
    current_user.likes.reload
    @liked_unit_groups = current_user.likes.sort_by{ |liked_unit| liked_unit.unit.unit_type.name }.group_by{ |liked_unit| { name: liked_unit.unit.unit_type.name, state: liked_unit.unit.state } }
    @liked_units_count = current_user.likes.size
  end

  #------------------------------------------------------------------------------
  private

  def find_likable_unit
    @likable_unit = Unit.find(params[:id])
  end
end
