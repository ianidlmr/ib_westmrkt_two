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
#  floor_plan_image       :string
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
  def floor_plan_image_url
    Setting.amazon_s3_bucket_url + name.tr(' ', '-').downcase + '_floorplan.png'
  end

  def quantity_remaining
    units.where(state: :available).count
  end

  def available_units?
    quantity_remaining.positive?
  end

  def total_views
    self.class.includes(:units).find(self).units.map(&:views).reduce(:+)
  end

  def last_chance?
    quantity_remaining <= Setting.last_chance_limit
  end

  def trending?
    total_views >= Setting.trending_limit
  end

  def total_bedrooms
   number_of_bedrooms > 0 ? number_of_bedrooms.to_s : 'S'
  end

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  # private
end
