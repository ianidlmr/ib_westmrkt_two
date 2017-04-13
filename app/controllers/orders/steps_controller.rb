# frozen_string_literal: true
class Orders::StepsController < ApplicationController
  include Wicked::Wizard

  steps :'update-personal-info', :'finalize-payment', :'order-confirmation'

  def show
    @order = current_user.orders.in_progress.find_by(unit_id: params[:unit_id])
    @unit = @order.unit
    render_wizard
  end

  def update
    @order = current_user.orders.in_progress.find_by(unit_id: params[:unit_id])
    @unit = @order.unit
    redirect_to wizard_path(:'finalize-payment')
  end
end