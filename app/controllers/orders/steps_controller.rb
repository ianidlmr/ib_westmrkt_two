# frozen_string_literal: true
class Orders::StepsController < ApplicationController
  include Wicked::Wizard

  steps :'update-personal-info', :'finalize-payment', :'order-confirmation'

  def show
    @unit = Unit.on_hold.find(params[:unit_id])
    handle_tasks_for_current_step; return if performed?
    render_wizard
  rescue ActiveRecord::RecordNotFound => e
    redirect_to units_path, alert: 'This unit is not available.' and return
  end

  def update
    @unit = Unit.on_hold.find(params[:unit_id])
    handle_tasks_for_current_step; return if performed?
    @order.update_attributes(order_params(@step))
    if @order.save
      @order.update_column(:current_step, next_step)
      redirect_to next_wizard_path
    else
      render_wizard @appointment
    end
  end

  private

  def handle_tasks_for_current_step
    # @order.process_payment!
    # @order.update_attributes(order_params(step))
    case @step.to_s
      when 'update-personal-info'
        @order = current_user.orders.in_progress.find_by(unit: @unit)
        redirect_to units_path, alert: 'You are only allowed one order at the moment. If you would like more please contact our agents.' and return unless @order.present?
      when 'finalize-payment'
        @order = current_user.orders.in_progress.find_by(unit: @unit)
        redirect_to wizard_path(:'update-personal-info'), alert: 'Fill in your personal information.' and return unless !@order.present? && @order.user.personal_info_filled_in?
      when 'order-confirmation'
        @order = current_user.orders.pending_verification.find_by(unit: @unit)
        redirect_to wizard_path(:'finalize-payment'), alert: 'Fill in your payment details and agree to our terms.' and return unless @order.present?
    end
  end

  def order_params(step)
    permitted_attributes = case step.to_s
      when 'update-personal-info'
        [user_attributes: [:first_name, :last_name, :phone_number, :occupation]]
      when 'finalize-payment'
        [:agree_to_deal_sheet, :agree_to_terms_and_conditions, :broker]
      when 'order-confirmation'
        []
      end
    params.require(:order).permit(permitted_attributes)
  end
end