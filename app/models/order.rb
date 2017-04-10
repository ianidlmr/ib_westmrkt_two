# == Schema Information
#
# Table name: orders
#
#  id                            :integer          not null, primary key
#  state                         :string
#  user_id                       :integer
#  stripe_charge_id              :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  unit_id                       :integer
#  payment_confirmed             :boolean          default("false")
#  promo_code                    :string
#  agree_to_deal_sheet           :boolean          default("false")
#  agree_to_terms_and_conditions :boolean          default("false")
#  broker                        :boolean          default("false")
#
# Indexes
#
#  index_orders_on_unit_id  (unit_id)
#  index_orders_on_user_id  (user_id)
#

class Order < ApplicationRecord
  #------------------------------------------------------------------------------
  # Associations
  belongs_to :user
  belongs_to :unit
  accepts_nested_attributes_for :user

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
  # def confirm_payment
  #   payment_confirmed - BOOLEAN
  #   order.unit.not_available
  # end

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  # private
end
