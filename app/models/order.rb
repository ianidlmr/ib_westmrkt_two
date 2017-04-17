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
#  agree_to_deal_sheet           :boolean          default("false")
#  agree_to_terms_and_conditions :boolean          default("false")
#  broker                        :boolean          default("false")
#  payment_state                 :string           default("in_progress")
#  current_step                  :string           default("update-personal-info")
#
# Indexes
#
#  index_orders_on_unit_id  (unit_id)
#  index_orders_on_user_id  (user_id)
#

class Order < ApplicationRecord
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
  validates :stripe_charge_id, :agree_to_deal_sheet, :agree_to_terms_and_conditions, :broker, presence: true, if: :pending_verification?

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
        unit.purchase!(nil, order)
        send_payment_success_email
      end
    end

    event :fail_payment do
      transitions from: :pending_verification, to: :failed
      after do
        send_payment_failed_email
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
          amount: total_fee_cents,
          currency: total_fee_currency.downcase,
          source: user.stripe_token,
          metadata: {
            order_id: id,
            user_id: user.id,
            user_email: user.email,
            unit_id: unit.id,
          }
        )
        return true
      rescue Stripe::CardError => e
        Rails.logger.info("Failed to charge user (#{user.id}) for order (#{id}): CARD ERROR")
        fail_payment!
        return false
      end
    else
      Rails.logger.info("Failed to charge user (#{user.id}) for order (#{id}): STRIPE USER (#{user.stripe_token}) NOT FOUND")
      return false
    end
  end

  def send_payment_success_email
    options = {
      to: user.email,
      subject: 'You have successfully pre-ordered a unit at Railway Market',
      template_id: '72acd583-1649-49ef-9fbd-41a1d42a6ada',
      substitutions: {
        # '-url-':
      }
    }
    ApplicationMailer.sendgrid_send(options).deliver_now
  end

  def send_payment_failed_email
    options = {
      to: user.email,
      subject: 'Something went wrong while processing your payment at Railway Market',
      template_id: '3e076287-1dab-4cee-be0f-055d94d0cbef',
      substitutions: {
        # '-url-':
      }
    }
    ApplicationMailer.sendgrid_send(options).deliver_now
  end
end
