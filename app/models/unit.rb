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
#  state        :string           default("available")
#  owner_id     :integer
#
# Indexes
#
#  index_units_on_owner_id      (owner_id)
#  index_units_on_unit_type_id  (unit_type_id)
#

class Unit < ApplicationRecord
  include AASM

  #------------------------------------------------------------------------------
  # Associations
  belongs_to :owner, class_name: 'User'
  belongs_to :unit_type
  has_many :likes
  has_many :users, through: :likes
  has_many :orders

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
    state :purchased

    after_all_transitions :aasm_log_status_change

    #--------------------------------------
    # Events
    event :hold do
      transitions from: :available, to: :on_hold
    end

    event :purchase do
      transitions from: :on_hold, to: :purchased, after: Proc.new { |order|
        update_column(:owner_id, order.user.id)
      }
    end

    event :cancel_hold do
      transitions from: [:on_hold, :purchased], to: :available
      after do
        update_column(:owner_id, nil)
      end
    end
  end

  #------------------------------------------------------------------------------
  # Class methods

  #------------------------------------------------------------------------------
  # Instance methods
  def views
    Ahoy::Event.all.map { |event| event.properties['id'] }.count(id.to_s)
  end

  def trending?
    views >= Setting.trending_limit
  end

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  private

  #--------------------------------------
  # AASM STATE methods
  def aasm_log_status_change
    logger.debug "Unit state changing from #{aasm(:state).from_state} to #{aasm(:state).to_state} (event: #{aasm(:state).current_event})"
  end
end
