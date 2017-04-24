class SearchController < ApplicationController
  def search
    @unit = Unit.find_by(unit_number: params[:unit_number])
    if @unit.present?
      redirect_to unit_type_unit_path(@unit.unit_type, @unit)
    end
  end
end