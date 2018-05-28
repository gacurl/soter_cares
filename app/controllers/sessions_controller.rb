class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password]) 
      if user.activated?
        if user.disable != true
          log_in user
          redirect_back_or user
        else
          message  = "Account is disabled. "
          message += "Please contact an administrator."
          
          flash[:danger] = message
          redirect_to :controller => 'static_pages', :action => 'home'
        end
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        
        flash[:warning] = message
        redirect_to :controller => 'static_pages', :action => 'home', 
                  :id => user, :type => "need_activate"
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
