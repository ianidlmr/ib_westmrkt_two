# frozen_string_literal: true
class LikesController < ApplicationController
  before_action :find_likable_unit, only: [:like_unit, :unlike_unit]

  def like_unit
    @likable_unit.likes.create(user: current_user) if @likable_unit.present?
    @liked_unit_groups = current_user.liked_units.sort_by{ |liked_unit| liked_unit.unit.unit_type.name }.group_by{ |liked_unit| { name: liked_unit.unit.unit_type.name, state: liked_unit.unit.state } }
    @liked_units_count = current_user.liked_units.count
  end

  def unlike_unit
    current_user.liked_units.where(unit: @likable_unit).first.destroy! if @likable_unit.present?
    @liked_unit_groups = current_user.liked_units.sort_by{ |liked_unit| liked_unit.unit.unit_type.name }.group_by{ |liked_unit| { name: liked_unit.unit.unit_type.name, state: liked_unit.unit.state } }
    @liked_units_count = current_user.liked_units.count
  end

  #------------------------------------------------------------------------------
  private

  def find_likable_unit
    @likable_unit = Unit.find(params[:id])
  end
end
