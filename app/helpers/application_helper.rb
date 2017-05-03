# frozen_string_literal: true
module ApplicationHelper
  def price_converter(amount)
    if amount >= 10_000 && amount < 1_000_000
      (amount / 1000).to_s + 'K'
    else
      (amount / 1_000_000).to_f.to_s + 'M'
    end
  end

  def circle_class
    if @liked_units_count.present? && @liked_units_count == 1
      'circle-pulse'
    else
      'circle-white'
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
