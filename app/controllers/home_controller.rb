# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    options = UnitType.select(:number_of_bedrooms).distinct.sort_by { |unit_type| unit_type.number_of_bedrooms == 0 ? 4 : unit_type.number_of_bedrooms }
    @options = options.map do |unit_type|
      if unit_type.number_of_bedrooms == 0
        ['Studios', 0]
      else
        ["#{unit_type.number_of_bedrooms}" + ' bedroom suites', unit_type.number_of_bedrooms]
      end
    end
  end

  def about; end

  def help; end

  def terms_and_privacy; end

  def specifications; end

  def send_confirmation
    current_user.send_confirmation_instructions
    flash[:notice] = 'Confirmation instructions have been sent to your email.'
    redirect_to :back
  end
end
