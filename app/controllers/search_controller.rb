# frozen_string_literal: true
class SearchController < ApplicationController
  def search
    if params[:den].present? && params[:balcony].present?
      @one_bedroom_units = UnitType.where('number_of_bedrooms = ? AND number_of_bathrooms = ? AND den = ? AND balcony = ?', 1, 1, params[:den], params[:balcony]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
      @two_bedroom_units = UnitType.where('number_of_bedrooms = ? AND number_of_bathrooms = ? AND den = ? AND balcony = ?', 2, 1, params[:den], params[:balcony]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
      @three_plus_bedroom_units = UnitType.where('number_of_bedrooms >= ? AND number_of_bathrooms = ? AND den = ? AND balcony = ?', 3, 1, params[:den], params[:balcony]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
    elsif params[:balcony].present?
      @one_bedroom_units = UnitType.where('number_of_bedrooms = ? AND number_of_bathrooms = ? AND balcony = ?', 1, 1, params[:balcony]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
      @two_bedroom_units = UnitType.where('number_of_bedrooms = ? AND number_of_bathrooms = ? AND balcony = ?', 2, 1, params[:balcony]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
      @three_plus_bedroom_units = UnitType.where('number_of_bedrooms >= ? AND number_of_bathrooms = ? AND balcony = ?', 3, 1, params[:balcony]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
    elsif params[:den].present?
      @one_bedroom_units = UnitType.where('number_of_bedrooms = ? AND number_of_bathrooms = ? AND den = ?', 1, 1, params[:den]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
      @two_bedroom_units = UnitType.where('number_of_bedrooms = ? AND number_of_bathrooms = ? AND den = ?', 2, 1, params[:den]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
      @three_plus_bedroom_units = UnitType.where('number_of_bedrooms >= ? AND number_of_bathrooms = ? AND den = ?', 3, 1, params[:den]).joins(:units).where('units.price > ?', 100000).map(&:units).flatten
    end
  end
end
