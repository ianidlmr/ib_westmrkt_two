# frozen_string_literal: true
class UnitsController < ApplicationController
  def index
    @one_bedroom_units = UnitType.where('number_of_bedrooms = ?', 1)
    @two_bedroom_units = UnitType.where('number_of_bedrooms = ?', 2)
    @three_plus_bedroom_units = UnitType.where('number_of_bedrooms >= ?', 3)

    if params[:search].present?
      @number_of_bedrooms = params[:search].split('')[0]
    end

    ordered_units_by_price = UnitType.available.joins(:units).order('units.price').map(&:units).flatten
    @lowest_price = ordered_units_by_price.first.price
    @highest_price = ordered_units_by_price.last.price

    @one_bedroom_units = @one_bedroom_units.map(&:units).flatten
    @two_bedroom_units = @two_bedroom_units.map(&:units).flatten
    @three_plus_bedroom_units = @three_plus_bedroom_units.map(&:units).flatten
  end

  def show
    @unit = Unit.find(params[:id])
  end
end
