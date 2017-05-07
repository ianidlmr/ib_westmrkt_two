# frozen_string_literal: true
# == Schema Information
#
# Table name: orders
#
#  id                            :integer          not null, primary key
#  user_id                       :integer
#  stripe_charge_id              :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  unit_id                       :integer
#  promo_code                    :string
#  agree_to_deal_sheet_and_terms :boolean          default("false")
#  broker                        :boolean          default("false")
#  payment_state                 :string           default("in_progress")
#  current_step                  :string           default("update-personal-info")
#  sale_person_name              :string
#
# Indexes
#
#  index_orders_on_unit_id  (unit_id)
#  index_orders_on_user_id  (user_id)
#

class Order < ApplicationRecord
  include Rails.application.routes.url_helpers
  include AASM

  #------------------------------------------------------------------------------
  # Associations
  belongs_to :user
  belongs_to :unit
  accepts_nested_attributes_for :user

  #------------------------------------------------------------------------------
  # Scopes

  #------------------------------------------------------------------------------
  # Validations
  validates :user_id, :unit_id, presence: true, if: :in_progress?
  validates :stripe_charge_id, :agree_to_deal_sheet_and_terms, :broker, presence: true, if: :pending_verification?

  #------------------------------------------------------------------------------
  # Callbacks

  #------------------------------------------------------------------------------
  # Enumerations

  #------------------------------------------------------------------------------
  # AASM Definitions
  aasm(:payment_state) do
    state :in_progress, initial: true
    state :pending_verification
    state :successful
    state :failed
    state :refunded
    state :expired

    after_all_transitions :aasm_log_status_change

    #--------------------------------------
    # Events
    event :process_payment do
      transitions from: :in_progress, to: :pending_verification, guard: :charge_successful?
    end

    event :confirm_payment do
      transitions from: :pending_verification, to: :successful
      after do
        unit.purchase!(nil, self)
        send_payment_success_email
      end
    end

    event :fail_payment do
      transitions from: :pending_verification, to: :failed
      after do
        send_payment_failed_email
      end
    end

    event :refund_payment do
      transitions from: [:pending_verification, :successful], to: :refunded
      after do
        send_payment_refunded_email
        unit.cancel_hold!
      end
    end

    event :expire do
      transitions from: :in_progress, to: :expired
      after do
        unit.cancel_hold!
      end
    end
  end

  #------------------------------------------------------------------------------
  # Class methods

  #------------------------------------------------------------------------------
  # Instance methods
  def confirmation_number
    id.to_s + '-' + stripe_charge_id.gsub('ch_', '')
  end

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  private

  #--------------------------------------
  # AASM STATE methods
  def aasm_log_status_change
    logger.debug "Order state changing from #{aasm(:payment_state).from_state} to #{aasm(:payment_state).to_state} (event: #{aasm(:payment_state).current_event})"
  end

  def charge_successful?
    stripe_customer = Stripe::Customer.retrieve(user.stripe_token)

    if stripe_customer.present?
      begin
        charge = Stripe::Charge.create(
          amount: 3000,
          currency: unit.currency.downcase,
          customer: user.stripe_token,
          metadata: {
            order_id: id,
            user_id: user.id,
            user_email: user.email,
            unit_id: unit.id
          }
        )
        update_column(:stripe_charge_id, charge.id)
        return true
      rescue Stripe::CardError => e
        Rails.logger.info("Failed to charge user (#{user.id}) for order (#{id}): CARD ERROR")
        return false
      end
    else
      Rails.logger.info("Failed to charge user (#{user.id}) for order (#{id}): STRIPE USER (#{user.stripe_token}) NOT FOUND")
      return false
    end
  end

  def send_payment_success_email
    ApplicationMailer.sendgrid_send(
      options = {
        to: user.email,
        subject: '',
        template_id: '72acd583-1649-49ef-9fbd-41a1d42a6ada',
        substitutions: {
          '-name-': unit.owner.first_name + ' ' + unit.owner.last_name,
          '-confirmation_number-': confirmation_number,
          '-date-': DateTime.now.strftime('%a, %B %e, %Y'),
          '-unit_number-': unit.unit_number.to_s,
          '-number_of_bedrooms-': unit.unit_type.number_of_bedrooms.to_s,
          '-den-': unit.unit_type.den ? 'Included' : 'Not Included',
          '-number_of_bathrooms-': unit.unit_type.number_of_bathrooms.to_s,
          '-balcony-': unit.unit_type.balcony ? 'Included' : 'Not Included',
          '-floor_number-': unit.floor_number.to_s,
          '-interior_sqft-': unit.unit_type.interior_sqft.to_s || '',
          '-balcony_sqft-': unit.unit_type.balcony_sqft.to_s || '',
          '-orientation-': unit.orientation
        }
      }
    ).deliver_now
  end

  def send_payment_failed_email
    ApplicationMailer.sendgrid_send(
      options = {
        to: user.email,
        subject: '',
        template_id: '3e076287-1dab-4cee-be0f-055d94d0cbef',
        substitutions: {
          '-amount-': '$3000.00',
          '-unit_number-': unit.unit_number.to_s
        }
      }
    ).deliver_now
  end

  def send_payment_refunded_email
    charge = Stripe::Charge.retrieve(stripe_charge_id)
    card_details = charge.source.brand + ' ending in ' + charge.source.last4

    ApplicationMailer.sendgrid_send(
      options = {
        to: user.email,
        subject: '',
        template_id: '3e0169a6-6fc8-4a2b-b0d6-6f28675c1a00',
        substitutions: {
          '-email-': user.email,
          '-amount-': '$3000.00',
          '-card_details-': card_details,
          '-unit_number-': unit.unit_number.to_s,
          '-help_url-': help_url
        }
      }
    ).deliver_now
  end
end
