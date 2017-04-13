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
    when 'customer.updated'
      customer_updated
    when 'charge.failed'
      charge_failed
    when 'charge.succeeded'
      charge_succeeded
    end

    render status: :ok, json: 'success'
  end

  private

  #------------------------------------------------------------------------------
  # EVENT HANDLING METHODS
  def customer_updated
    # => @object = Stripe::Customer
  end

  def charge_succeeded
    # => @object = Stripe::Charge
    @order = Order.find_by(stripe_charge_id: @object.id)
    if @order.present?
      @order.confirm_payment!
    end
  end

  def charge_failed
    # => @object = Stripe::Charge
    @order = Order.find_by(stripe_charge_id: @object.id)
    if @order.present?
      @order.fail_payment!
    end
  end

  #------------------------------------------------------------------------------
  # OTHER PRIVATE METHODS
  def debug_log_output
    Rails.logger.debug "*** STRIPE ACCOUNT WEBHOOK: #{@event.type} ***"
    Rails.logger.debug @event.inspect
    Rails.logger.debug '**********************'
  end
end
