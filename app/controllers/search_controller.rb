# frozen_string_literal: true
class SearchController < ApplicationController
  def search
    @unit = Unit.available.find_by(unit_number: params[:unit_number])
    redirect_to unit_type_unit_path(@unit.unit_type, @unit) if @unit.present?
  end
end
