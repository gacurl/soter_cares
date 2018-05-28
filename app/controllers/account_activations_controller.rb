class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if logged_in?
      log_out
    end
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated! Please create a password."
      redirect_to user_password_path(user)
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
