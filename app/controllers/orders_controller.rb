# frozen_string_literal: true
class OrdersController < ApplicationController
  before_action :can_checkout_unit?

  def new
    @unit = Unit.available.find(params[:unit_id])
    current_user.orders.in_progress.each(&:expire!)
    @order = current_user.orders.create!(unit: @unit)
    @unit.hold!
    redirect_to unit_step_path(@unit, @order.current_step) and return
  rescue ActiveRecord::RecordNotFound => e
    @unit = Unit.on_hold.find(params[:unit_id])
    @order = current_user.orders.in_progress.find_by(unit: @unit)
    redirect_to unit_step_path(@unit, @order.current_step) and return
  end

  private

  def can_checkout_unit?
    if (current_user.orders.successful.count > 0 || current_user.orders.pending_verification.count > 0) && !current_user.allow_multiple_orders
      flash[:error] = 'You are only allowed one order at the moment. If you would like more please contact our agents.'
      redirect_to unit_types_path and return
    end
  end
end