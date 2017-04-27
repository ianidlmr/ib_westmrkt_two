# frozen_string_literal: true
class Api::V1::Stripe::AccountController < Api::V1::Stripe::BaseController
  def create
    begin
      @event = Stripe::Event.retrieve(params[:id])
    rescue StandardError => e
      Rails.logger.debug "  >>>> EVENT COULD NOT BE FOUND: #{e.message if e.message.present?}"
      render(status: :bad_request, json: 'bad request') && return
    end
    debug_log_output
    @object = @event.data.object

    case @event.type
    when 'charge.failed'
      charge_failed
    when 'charge.succeeded'
      charge_succeeded
    when 'charge.refunded'
      charge_refunded
    end

    render status: :ok, json: 'success'
  end

  private

  #------------------------------------------------------------------------------
  # EVENT HANDLING METHODS
  def charge_succeeded
    # => @object = Stripe::Charge
    @order = Order.find_by(stripe_charge_id: @object.id)
    @order.confirm_payment! if @order.present? && @order.may_confirm_payment?
  end

  def charge_failed
    # => @object = Stripe::Charge
    @order = Order.find_by(stripe_charge_id: @object.id)
    @order.fail_payment! if @order.present? && @order.may_fail_payment?
  end

  def charge_refunded
    # => @object = Stripe::Charge
    @order = Order.find_by(stripe_charge_id: @object.id)
    @order.refund_payment! if @order.present? && @order.may_refund_payment?
  end

  #------------------------------------------------------------------------------
  # OTHER PRIVATE METHODS
  def debug_log_output
    Rails.logger.debug "*** STRIPE ACCOUNT WEBHOOK: #{@event.type} ***"
    Rails.logger.debug @event.inspect
    Rails.logger.debug '**********************'
  end
end
