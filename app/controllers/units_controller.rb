# frozen_string_literal: true
class UnitsController < ApplicationController
  include ApplicationHelper

  after_action :track_action, only: [:show]

  def show
    @unit = Unit.find_by(id: params[:id], unit_type_id: params[:unit_type_id])
    @unit_type = @unit.unit_type
    @unit_views = @unit.views
    @select_options = Unit.available.where(unit_type: @unit.unit_type).map do |unit|
      {
        number: unit.unit_number,
        price: price_converter(unit.price).to_s + ' ' + unit.currency,
        orientation: unit.orientation,
        url: unit_type_unit_path(@unit_type, unit)
      }.to_json
    end
    @selected_option = {
      number: @unit.unit_number,
      price: price_converter(@unit.price).to_s + ' ' + @unit.currency,
      orientation: @unit.orientation,
      url: unit_type_unit_path(@unit_type, @unit)
    }.to_json
  end

  private

  def track_action
    ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
  end
end
