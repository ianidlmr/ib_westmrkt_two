# frozen_string_literal: true
# == Schema Information
#
# Table name: units
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  unit_number  :integer
#  floor_number :integer
#  orientation  :string
#  price        :integer
#  savings      :integer
#  currency     :string
#  unit_type_id :integer
#  state        :string
#
# Indexes
#
#  index_units_on_unit_type_id  (unit_type_id)
#

class Unit < ApplicationRecord
  include AASM

  #------------------------------------------------------------------------------
  # Associations
  belongs_to :unit_type
  has_many :likes
  has_many :users, through: :likes
  has_one :order

  #------------------------------------------------------------------------------
  # Scopes

  #------------------------------------------------------------------------------
  # Validations

  #------------------------------------------------------------------------------
  # Callbacks

  #------------------------------------------------------------------------------
  # Enumerations

  #------------------------------------------------------------------------------
  # AASM definitions
  aasm(:state) do
    state :available, initial: true
    state :on_hold
    state :bought

    after_all_transitions :aasm_log_status_change

    #--------------------------------------
    # Events
    event :place_order do
      transitions from: :available, to: :on_hold
    end

    event :complete_order do
      transitions from: :on_hold, to: :bought
    end

    event :cancel_order do
      transitions from: :bought, to: :available
    end
  end

  #------------------------------------------------------------------------------
  # Class methods

  #------------------------------------------------------------------------------
  # Instance methods

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  # private
end
