# frozen_string_literal: true
class UnitTypesController < ApplicationController
  def index
    unit_types = UnitType.joins(:units).distinct.order(:name).where(querybuilder(params))
    @zero_bedroom_unit_types = unit_types.where(number_of_bedrooms: 0).select(&:available_units?).sort_by { |unit_type| unit_type.trending? ? 0 : 1 }.sort_by { |unit_type| unit_type.last_chance? ? 0 : 1 }
    @one_bedroom_unit_types = unit_types.where(number_of_bedrooms: 1).select(&:available_units?).sort_by { |unit_type| unit_type.trending? ? 0 : 1 }.sort_by { |unit_type| unit_type.last_chance? ? 0 : 1 }
    @two_bedroom_unit_types = unit_types.where(number_of_bedrooms: 2).select(&:available_units?).sort_by { |unit_type| unit_type.trending? ? 0 : 1 }.sort_by { |unit_type| unit_type.last_chance? ? 0 : 1 }
    @three_plus_bedroom_unit_types = unit_types.where('number_of_bedrooms >= ?', 3).select(&:available_units?).sort_by { |unit_type| unit_type.trending? ? 0 : 1 }.sort_by { |unit_type| unit_type.last_chance? ? 0 : 1 }

    @lowest_price = Unit.available.order(:price).first.price
    @highest_price = Unit.available.order(:price).last.price

    if params[:number_of_bedrooms].present?
      @number_of_bedrooms = params[:number_of_bedrooms].split('')[0]
    end
  end

  private

  def querybuilder(params)
    [
      {
        param: :den,
        query: proc { |value| "den = #{value}" }
      }, {
        param: :balcony,
        query: proc { |value| "balcony = #{value}" }
      }, {
        param: :number_of_bathrooms,
        query: proc { |value| value == '3' ? "number_of_bathrooms >= #{value}" : "number_of_bathrooms = #{value}" }
      }, {
        param: :price,
        query: proc { |value| "units.price <= #{value}" }
      }
    ].select { |filter| params.key?(filter[:param]) && params[filter[:param]].present? }
      .map { |filter| filter[:query].call(params[filter[:param]]) }
      .join(' and ')
  end
end
