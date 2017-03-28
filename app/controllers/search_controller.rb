# frozen_string_literal: true
class SearchController < ApplicationController
  def search
binding.pry
    @one_bedroom_units = UnitType.where('number_of_bedrooms = ? AND number_of_bathrooms = ? AND den = ? AND balcony = ?', 1, 1, params[:den], params[:balcony]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
    @two_bedroom_units = UnitType.where('number_of_bedrooms = ? AND number_of_bathrooms = ? AND den = ? AND balcony = ?', 2, 1, params[:den], params[:balcony]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
    @three_plus_bedroom_units = UnitType.where('number_of_bedrooms >= ? AND number_of_bathrooms = ? AND den = ? AND balcony = ?', 3, 1, params[:den], params[:balcony]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
  end
end
