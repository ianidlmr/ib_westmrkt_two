# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string
#  uid                    :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider              (provider)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid                   (uid)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  #------------------------------------------------------------------------------
  # Associations

  #------------------------------------------------------------------------------
  # Scopes

  #------------------------------------------------------------------------------
  # Validations

  #------------------------------------------------------------------------------
  # Callbacks
  # after_create :create_stripe_account
  # after_save :update_stripe_account, if: :email_changed?

  #------------------------------------------------------------------------------
  # Enumerations

  #------------------------------------------------------------------------------
  # Class methods

  def self.from_omniauth(auth)
    if User.find_by(provider: auth.provider, uid: auth.uid).present?
      # User has used this OAuth provider before
      # We prefer using provider and uid because the user/provider may have revoked ability to see the email
      User.find_by(provider: auth.provider, uid: auth.uid)
    elsif User.find_by(email: auth.info.email).present?
      # User has not used OAuth before but does have a registered user account.
      # We set the provider and uid for future use.
      user = User.find_by(email: auth.info.email)
      user.update(provider: auth.provider, uid: auth.uid)
      user
    elsif auth.info.email.present?
      # User has never signed in and the oauth provider has returned an email address. Create the new account.
      User.omniauth_create(auth)
    end
  end

  def self.omniauth_create(auth)
    user = User.new(
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      provider: auth.provider,
      uid: auth.uid
    )
    # No need to confirm the email address when a user signs up from their social media account
    user.skip_confirmation!
    user.save
    user
  end

  #------------------------------------------------------------------------------
  # Instance methods

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  # private
  # def create_stripe_account
  #   unless stripe_token.present? || Rails.env.test?
  #     customer = Stripe::Customer.create(description: "User ID: #{id}", email: email)
  #     update_columns(stripe_token: customer.id)
  #   end
  # end

  # def update_stripe_account
  #   unless Rails.env.test?
  #     customer = Stripe::Customer.retrieve(stripe_token)
  #     customer.email = email
  #     customer.save
  #   end
  # end
end
