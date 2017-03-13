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
#

class Unit < ApplicationRecord

end
