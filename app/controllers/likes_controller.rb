# frozen_string_literal: true
class LikesController < ApplicationController
  before_action :find_likable_unit, only: [:like_unit, :unlike_unit]

  def like_unit
    @likable_unit.likes.create(user: current_user) if @likable_unit.present?
    @liked_units = current_user.liked_units
  end

  def unlike_unit
    current_user.liked.where(unit: @likable_unit).first.destroy if @likable_unit.present?
    @liked_units = current_user.liked_units
  end

  #------------------------------------------------------------------------------
  private

  def find_likable_unit
    @likable_unit = Unit.find params[:id]
  end
end
