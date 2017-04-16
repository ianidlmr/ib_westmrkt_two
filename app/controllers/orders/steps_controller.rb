# frozen_string_literal: true
class Orders::StepsController < ApplicationController
  include Wicked::Wizard

  steps :'update-personal-info', :'finalize-payment', :'order-confirmation'

  def show
    @unit = Unit.on_hold.find(params[:unit_id])
    @order = current_user.orders.in_progress.find_by(unit: @unit)
    redirect_to units_path, alert: 'You are only allowed one order at the moment. If you would like more please contact our agents.' and return unless @order.present?

    handle_tasks_for_current_step; return if performed?
    render_wizard
  rescue ActiveRecord::RecordNotFound => e
    redirect_to units_path, alert: 'This unit is not available.' and return
  end

  def update
    @unit = Unit.on_hold.find(params[:unit_id])
    @order = current_user.orders.in_progress.find_by(unit_id: params[:unit_id])

    handle_tasks_for_current_step; return if performed?
    @order.update_column(:current_step, next_step)
    @unit = @order.unit
    redirect_to wizard_path(@order.current_step)
  end

  private

  def handle_tasks_for_current_step
    case @step.to_s
      when 'update-personal-info'
        # nothing
      when 'finalize-payment'
        redirect_to wizard_path(:'update-personal-info'), alert: 'Fill in your personal information.' and return unless @order.user.personal_info_filled_in?
      when 'order-confirmation'
        redirect_to wizard_path(:'finalize-payment'), alert: 'Fill in your payment details.' and return unless @order.pending_verification?
    end
  end
end