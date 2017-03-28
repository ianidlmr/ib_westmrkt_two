# frozen_string_literal: true
class SearchController < ApplicationController
  def search
    filtered_units = UnitType.where('number_of_bathrooms = ? AND den = ? AND balcony = ?', 1, true, true).joins(:units).where('units.price > ?', 10000).map(&:units).flatten
  end
end
