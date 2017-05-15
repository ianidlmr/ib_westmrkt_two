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

  def sale_state
    # pre_sale_start_date = Setting.pre_sale_start_date
    # pre_sale_start_date_epoch = (DateTime.parse(pre_sale_start_date).utc.to_f * 1000).floor
    # pre_sale_end_date = Setting.pre_sale_end_date
    # pre_sale_end_date_epoch = (DateTime.parse(pre_sale_end_date).utc.to_f * 1000).floor
    # current_time = (Time.zone.now.utc.to_f * 1000).floor
    # if current_time < pre_sale_start_date_epoch
    #   @epoch_time = pre_sale_start_date_epoch
    #   return 'pre_sale_not_started'
    # elsif pre_sale_end_date_epoch > current_time >= pre_sale_start_date_epoch
    #   @epoch_time = pre_sale_end_date_epoch
    #   return 'pre_sale_started'
    # else current_time >= pre_sale_end_date_epoch
    #   return 'pre_sale_closed'
    # end

    # For testing
    @epoch_time = ((DateTime.now + 30.days).utc.to_f * 1000).floor
    'pre_sale_started'
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
