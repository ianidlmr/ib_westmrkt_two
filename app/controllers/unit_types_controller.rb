# frozen_string_literal: true
class UnitTypesController < ApplicationController
  def index
    unit_types = UnitType.joins(:units).distinct.order(:name).where(querybuilder(params))
    @one_bedroom_unit_types = unit_types.where(number_of_bedrooms: 1).select{ |unit_type| unit_type.has_available_units? }.sort_by{ |unit_type| unit_type.trending? ? 0 : 1 }.sort_by{ |unit_type| unit_type.last_chance? ? 0 : 1 }
    @two_bedroom_unit_types = unit_types.where(number_of_bedrooms: 2).select{ |unit_type| unit_type.has_available_units? }.sort_by{ |unit_type| unit_type.trending? ? 0 : 1 }.sort_by{ |unit_type| unit_type.last_chance? ? 0 : 1 }
    @three_plus_bedroom_unit_types = unit_types.where('number_of_bedrooms >= ?', 3).select{ |unit_type| unit_type.has_available_units? }.sort_by{ |unit_type| unit_type.trending? ? 0 : 1 }.sort_by{ |unit_type| unit_type.last_chance? ? 0 : 1 }

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
        query: Proc.new { |value| "den = #{value}" }
      }, {
        param: :balcony,
        query: Proc.new { |value| "balcony = #{value}" }
      }, {
        param: :number_of_bathrooms,
        query: Proc.new { |value| value == '3' ? "number_of_bathrooms >= #{value}" : "number_of_bathrooms = #{value}" }
      }, {
        param: :price,
        query: Proc.new { |value| "units.price <= #{value}" }
      }
    ].select { |filter| (params.has_key?(filter[:param])) && params[filter[:param]].present? }
     .map { |filter| filter[:query].call(params[filter[:param]]) }
     .join(" and ")
  end

  def track_action
    ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
  end
end
