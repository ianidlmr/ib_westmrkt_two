# frozen_string_literal: true
class Orders::StepsController < ApplicationController
  include Wicked::Wizard

  steps :'update-personal-info', :'finalize-payment', :'order-confirmation'

  def show
    @unit = Unit.on_hold.find(params[:unit_id])
    handle_tasks_for_current_step; return if performed?
    render_wizard
  rescue ActiveRecord::RecordNotFound
    redirect_to(units_path, alert: 'This unit is not available.') && (return)
  end

  def update
    @unit = Unit.on_hold.find(params[:unit_id])
    handle_tasks_for_current_step; return if performed?

    if params[:order][:address].present?
      if params[:order][:promo_code].present?
        @order.update(promo_code: params[:order][:promo_code])
      end

      if @address.update_attributes(address_params) && current_user.update_attributes(order_params[:user_attributes])
        @order.update_column(:current_step, next_step)
        redirect_to next_wizard_path
      else
        render_wizard @order
      end
    end

    if params[:order][:broker].present?
      begin
        @order.update_attributes(order_params)
        if @order.process_payment!
          redirect_to next_wizard_path
        else
          render_wizard @order
        end
      rescue AASM::InvalidTransition
        redirect_to(wizard_path(:'finalize-payment'), alert: 'Please try again with a different card.') && return
      end
    end
  end

  private

  def handle_tasks_for_current_step
    case @step.to_s
    when 'update-personal-info'
      @order = current_user.orders.in_progress.find_by(unit: @unit)
      @address = Address.find_or_create_by!(user: current_user)
      redirect_to(units_path, alert: 'You are only allowed one order at the moment. If you would like more please contact our agents.') && return unless @order.present?
    when 'finalize-payment'
      @order = current_user.orders.in_progress.find_by(unit: @unit)
      redirect_to(wizard_path(:'update-personal-info'), alert: 'Fill in your personal information.') && return unless @order.present? && @order.user.personal_info_filled_in?
    when 'order-confirmation'
      @order = current_user.orders.pending_verification.find_by(unit: @unit)
      redirect_to(wizard_path(:'finalize-payment'), alert: 'Fill in your payment details and agree to our terms.') && return unless @order.present?
    end
  end

  def order_params
    permitted_attributes = case @step.to_s
      when 'update-personal-info'
        [user_attributes: [:first_name, :last_name, :phone_number, :occupation]]
      when 'finalize-payment'
        [:agree_to_deal_sheet_and_terms, :broker]
      end
    params.require(:order).permit(permitted_attributes)
  end

  def address_params
    params.require(:order).permit(address: [:street_1, :street_2, :city, :state, :postal_code, :country])[:address]
  end
end
