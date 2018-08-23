class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def remote_ip
    if Rails.env.development?
      # Hard coded remote address
      '24.3.158.222'
    else
      request.remote_ip
    end
  end
end
