# frozen_string_literal: true
# == Schema Information
#
# Table name: addresses
#
#  id           :integer          not null, primary key
#  street_1     :string
#  street_2     :string
#  city         :string
#  state        :string
#  postal_code  :string
#  country_code :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_addresses_on_user_id  (user_id)
#

class Address < ApplicationRecord
  #------------------------------------------------------------------------------
  # Associations
  belongs_to :user

  #------------------------------------------------------------------------------
  # Scopes

  #------------------------------------------------------------------------------
  # Validations
  validates :street_1, :city, :state, :postal_code, :country_code, presence: true

  #------------------------------------------------------------------------------
  # Callbacks

  #------------------------------------------------------------------------------
  # Enumerations

  #------------------------------------------------------------------------------
  # Class methods
  def self.select_options_for_province
    [
      ['Alberta', 'AB'],
      ['British Columbia', 'BC'],
      ['Manitoba', 'MB'],
      ['New Brunswick', 'NB'],
      ['Newfoundland and Labrador', 'NL'],
      ['Northwest Territories', 'NT'],
      ['Nova Scotia', 'NS'],
      ['Nunavut', 'NU'],
      ['Ontario', 'ON'],
      ['Prince Edward Island', 'PE'],
      ['Quebec', 'QC'],
      ['Saskatchewan', 'SK'],
      ['Yukon', 'YT']
    ]
  end

  #------------------------------------------------------------------------------
  # Instance methods

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  # private
end
