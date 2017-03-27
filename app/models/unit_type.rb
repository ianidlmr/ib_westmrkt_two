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
#  quantity_remaining     :integer
#  number_of_bedrooms     :integer
#  number_of_bathrooms    :integer
#  balcony_sqft           :integer
#  interior_sqft          :integer
#  den                    :boolean
#  balcony                :boolean
#

class UnitType < ApplicationRecord
  has_many :units
end
