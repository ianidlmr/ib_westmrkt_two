# frozen_string_literal: true
class HomeController < ApplicationController
  def index
  end

  def about
  end

  def help
  end

  def terms_and_privacy
  end

  def specifications
  end

  def send_confirmation
    current_user.send_confirmation_instructions
    flash[:notice] = 'Confirmation instructions have been sent to your email.'
    redirect_to :back
  end
end
