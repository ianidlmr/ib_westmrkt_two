# frozen_string_literal: true
class OrdersController < ApplicationController
  include ApplicationHelper
  before_action :can_checkout_unit?

  def new
    @unit = Unit.available.find(params[:unit_id])
    current_user.orders.in_progress.each(&:expire!)
    @order = current_user.orders.create!(unit: @unit)
    @unit.hold!
    redirect_to(unit_step_path(@unit, @order.current_step)) && return
  rescue ActiveRecord::RecordNotFound => e
    @unit = Unit.on_hold.find(params[:unit_id])
    @order = current_user.orders.in_progress.find_by(unit: @unit)
    redirect_to(unit_step_path(@unit, @order.current_step)) && return
  end

  private

  def can_checkout_unit?
    if sale_state == 'pre_sale_not_started'
      flash[:error] = 'Pre-sale of units has not started yet.'
      redirect_to(unit_types_path) && return
    end

    if sale_state == 'pre_sale_ended'
      flash[:error] = 'Pre-sale of units has ended.'
      redirect_to(unit_types_path) && return
    end

    unless current_user.confirmed?
      flash[:error] = 'Please check your email to confirm your email address before continuing.'
      redirect_to(unit_types_path) && return
    end

    if (current_user.orders.successful.count.positive? || current_user.orders.pending_verification.count.positive?) && !current_user.allow_multiple_orders
      flash[:error] = 'You are only allowed one order at the moment. If you would like more please contact our agents.'
      redirect_to(unit_types_path) && return
    end
  end
end
