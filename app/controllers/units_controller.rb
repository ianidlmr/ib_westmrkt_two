# frozen_string_literal: true
class UnitsController < ApplicationController
  after_action :track_action, only: [:show]

  def index
    @one_bedroom_units = UnitType.joins(:units)
      .where('number_of_bedrooms = ?', 1)
      .where(querybuilder(params))
      .distinct
      .order(:name)
      .map(&:units)
      .flatten
      .delete_if{ |unit| unit.state == 'on_hold' }
      .delete_if{ |unit| unit.state == 'purchased' }

    @two_bedroom_units = UnitType.joins(:units)
      .where('number_of_bedrooms = ?', 2)
      .where(querybuilder(params))
      .distinct
      .order(:name)
      .map(&:units)
      .flatten
      .delete_if{ |unit| unit.state == 'on_hold' }
      .delete_if{ |unit| unit.state == 'purchased' }

    @three_plus_bedroom_units = UnitType.joins(:units)
      .where('number_of_bedrooms >= ?', 3)
      .where(querybuilder(params))
      .distinct
      .order(:name)
      .map(&:units)
      .flatten
      .delete_if{ |unit| unit.state == 'on_hold' }
      .delete_if{ |unit| unit.state == 'purchased' }

    @lowest_price = Unit.available.order(:price).first.price
    @highest_price = Unit.available.order(:price).last.price

    if params[:number_of_bedrooms].present?
      @number_of_bedrooms = params[:number_of_bedrooms].split('')[0]
    end
  end

  def show
    @unit = Unit.find(params[:id])
    @unit_views = Ahoy::Event.all.map { |event| event.properties['id'] }.count(@unit.id.to_s)
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
    ].select { |filter| params.has_key? filter[:param] && !params[filter[:param]].nil? }
     .map { |filter| filter[:query].call(params[filter[:param]]) }
     .join(" and ")
  end

  def track_action
    ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
  end
end
