# frozen_string_literal: true
class UnitsController < ApplicationController
  after_action :track_action, only: [:show]

  def show
    @unit = Unit.find_by(id: params[:id], unit_type_id: params[:unit_type_id])
    @unit_type = @unit.unit_type
    @unit_views = @unit.views
  end

  private

  def track_action
    ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
  end
end