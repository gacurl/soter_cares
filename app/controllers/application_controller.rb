class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def remote_ip
    if Rails.env.development?
      '24.3.158.222'
    else
      request.headers['x-forwarded-for'].split(',').first
    end
  end
end
