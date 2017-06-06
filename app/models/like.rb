# frozen_string_literal: true
# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  unit_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_likes_on_unit_id  (unit_id)
#  index_likes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (unit_id => units.id)
#  fk_rails_...  (user_id => users.id)
#

class Like < ApplicationRecord
  #------------------------------------------------------------------------------
  # Associations
  belongs_to :unit
  belongs_to :user

  #------------------------------------------------------------------------------
  # Scopes

  #------------------------------------------------------------------------------
  # Validations
  validates :user_id, uniqueness: { scope: :unit_id }

  #------------------------------------------------------------------------------
  # Callbacks

  #------------------------------------------------------------------------------
  # Enumerations

  #------------------------------------------------------------------------------
  # Class methods

  #------------------------------------------------------------------------------
  # Instance methods

  #------------------------------------------------------------------------------
  # Rails Admin Config

  #------------------------------------------------------------------------------
  # private
end
