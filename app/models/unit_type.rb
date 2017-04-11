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
    Unit.where(unit_type: self, state: :available).count
  end

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  # private
end
