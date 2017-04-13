# frozen_string_literal: true
class OrdersController < ApplicationController
  def new
    if current_user.orders.in_progress.find_by(unit_id: params[:unit_id]).present?
      @order = current_user.orders.in_progress.find_by(unit_id: params[:unit_id])
      @unit = @order.unit
    else
      current_user.orders.in_progress.each(&:destroy!)
      @unit = Unit.available.find(params[:unit_id])
      @order = current_user.orders.new(unit: @unit)
      @unit.place_order!
      @order.save
    end
    redirect_to unit_step_path(@unit, Order.steps.first)
  rescue ActiveRecord::RecordNotFound => e
    flash[:error] = 'This unit is no longer available.'
    redirect_to units_path
  end
end
