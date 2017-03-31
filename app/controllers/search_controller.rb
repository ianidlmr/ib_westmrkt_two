# frozen_string_literal: true
class SearchController < ApplicationController
  def search
    # @bathroom_units = (1..3).map { |unit|  UnitType.where('number_of_bedrooms', unit )}
    @one_bedroom_units = UnitType.where('number_of_bedrooms = ?', 1)
    @two_bedroom_units = UnitType.where('number_of_bedrooms = ?', 2)
    @three_plus_bedroom_units = UnitType.where('number_of_bedrooms >= ?', 3)

    if params[:den].present?
      # @bedroom_units.map { |units| }
      @one_bedroom_units = @one_bedroom_units.where('den = ?', params[:den])
      @two_bedroom_units = @two_bedroom_units.where('den = ?', params[:den])
      @three_plus_bedroom_units = @three_plus_bedroom_units.where('den = ?', params[:den])
    end

    if params[:balcony].present?
      @one_bedroom_units = @one_bedroom_units.where('balcony = ?', params[:balcony])
      @two_bedroom_units = @two_bedroom_units.where('balcony = ?', params[:balcony])
      @three_plus_bedroom_units = @three_plus_bedroom_units.where('balcony = ?', params[:balcony])
    end

    if params[:number_of_bathrooms].present?
      if params[:number_of_bathrooms] == '3'
        @one_bedroom_units = @one_bedroom_units.where('number_of_bathrooms >= ?', params[:number_of_bathrooms])
        @two_bedroom_units = @two_bedroom_units.where('number_of_bathrooms >= ?', params[:number_of_bathrooms])
        @three_plus_bedroom_units = @three_plus_bedroom_units.where('number_of_bathrooms >= ?', params[:number_of_bathrooms])
      else
        @one_bedroom_units = @one_bedroom_units.where('number_of_bathrooms = ?', params[:number_of_bathrooms])
        @two_bedroom_units = @two_bedroom_units.where('number_of_bathrooms = ?', params[:number_of_bathrooms])
        @three_plus_bedroom_units = @three_plus_bedroom_units.where('number_of_bathrooms = ?', params[:number_of_bathrooms])
      end
    end

    # bedroom_units.each { |units| map(&:units).flatten }
    @one_bedroom_units = @one_bedroom_units.map(&:units).flatten
    @two_bedroom_units = @two_bedroom_units.map(&:units).flatten
    @three_plus_bedroom_units = @three_plus_bedroom_units.map(&:units).flatten
  end
end
