class Users::StripeController < ApplicationController
  def add_card_to_stripe
    @stripe_customer = Stripe::Customer.retrieve(current_patient.stripe_token)
    begin
      card = @stripe_customer.sources.create({:source => params[:token]}) if params[:token].present?

      if card.present? && @stripe_customer.default_source != card.id
        @stripe_customer.default_source = card.id
        @stripe_customer.save
      end
    rescue Exception => e
      @error_msg = e.message if e.message.present?
    end

    if @error_msg.present?
      render json: @error_msg
    else
      render layout: false
    end
  end
end
