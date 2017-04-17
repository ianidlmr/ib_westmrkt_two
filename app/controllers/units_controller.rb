# frozen_string_literal: true
class UnitsController < ApplicationController
  def index
    @one_bedroom_units = UnitType.where('number_of_bedrooms = ?', 1).order(:name)
    @two_bedroom_units = UnitType.where('number_of_bedrooms = ?', 2).order(:name)
    @three_plus_bedroom_units = UnitType.where('number_of_bedrooms >= ?', 3).order(:name)

    ordered_units_by_price = UnitType.joins(:units).order('units.price').map(&:units).flatten
    @lowest_price = ordered_units_by_price.first.price
    @highest_price = ordered_units_by_price.last.price

    if params[:number_of_bedrooms].present?
      @number_of_bedrooms = params[:number_of_bedrooms].split('')[0]
    end

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

    if params[:price].present?
      @one_bedroom_units = @one_bedroom_units.joins(:units).where('units.price <= ?', params[:price]).distinct
      @two_bedroom_units = @two_bedroom_units.joins(:units).where('units.price <= ?', params[:price]).distinct
      @three_plus_bedroom_units = @three_plus_bedroom_units.joins(:units).where('units.price <= ?', params[:price]).distinct
    end

    @one_bedroom_units = @one_bedroom_units.map(&:units).flatten
    @two_bedroom_units = @two_bedroom_units.map(&:units).flatten
    @three_plus_bedroom_units = @three_plus_bedroom_units.map(&:units).flatten
  end

  # @bathroom_units = (1..3).map { |unit|  UnitType.where('number_of_bedrooms', unit )}
  # bedroom_units.each { |units| map(&:units).flatten }
  def show
    @unit = Unit.find(params[:id])
  end
end
