# frozen_string_literal: true
# == Schema Information
#
# Table name: unit_types
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  description            :text
#  front_page_description :text
#  number_of_bedrooms     :integer
#  number_of_bathrooms    :integer
#  balcony_sqft           :integer
#  interior_sqft          :integer
#  den                    :boolean
#  balcony                :boolean
#

class UnitType < ApplicationRecord
  #------------------------------------------------------------------------------
  # Associations
  has_many :units

  #------------------------------------------------------------------------------
  # Scopes

  #------------------------------------------------------------------------------
  # Validations

  #------------------------------------------------------------------------------
  # Callbacks

  #------------------------------------------------------------------------------
  # Enumerations

  #------------------------------------------------------------------------------
  # Class methods

  #------------------------------------------------------------------------------
  # Instance methods
  def quantity_remaining
    units.where(state: :available).count
  end

  def has_available_units?
    quantity_remaining > 0
  end

  def total_views
    units.map(&:views).reduce(:+)
  end

  def last_chance?
    quantity_remaining <= Setting.last_chance_limit
  end

  def trending?
    total_views >= Setting.trending_limit
  end

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  # private
end
