# frozen_string_literal: true
class UnitsController < ApplicationController
  def index
    if params[:unit_type].present?
      @one_bedroom_units = UnitType.available.where('id = ? AND number_of_bedrooms = ?', params[:unit_type], 1).distinct.map(&:units).flatten
      @two_bedroom_units = UnitType.available.where('id = ? AND number_of_bedrooms = ?', params[:unit_type], 2).distinct.map(&:units).flatten
      @three_plus_bedroom_units = UnitType.available.where('id = ? AND number_of_bedrooms >= ?', params[:unit_type], 3).distinct.map(&:units).flatten
    else
      @one_bedroom_units = UnitType.available.where('number_of_bedrooms = 1').map(&:units).flatten
      @two_bedroom_units = UnitType.available.where('number_of_bedrooms = 2').map(&:units).flatten
      @three_plus_bedroom_units = UnitType.available.where('number_of_bedrooms >= 3').map(&:units).flatten
    end

    @lowest_price = UnitType.available.joins(:units).order('units.price').map(&:units).flatten.first.price
    @highest_price = UnitType.available.joins(:units).order('units.price').map(&:units).flatten.last.price
  end

  def show; end
end
