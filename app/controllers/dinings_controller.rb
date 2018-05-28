class DiningsController < ApplicationController
  before_action :admin_user
  
  def update_multiple
    @dinings = Dining.update(params[:dinings].keys, params[:dinings].values)
    @dinings.reject! { |p| p.errors.empty? }
    flash[:success] = "Dinings updated"
    redirect_to settings_path
  end
  
  def create
    Dining.create(dining_params)
    flash[:success] = "Dining option created"
    redirect_to settings_path
  end
  
  def update
    Dining.find(params[:id]).update(dining_params)
    flash[:success] = "Dining option updated"
    redirect_to settings_path
  end
  
  def destroy
    Dining.find(params[:id]).destroy
    flash[:success] = "Dining option deleted"
    redirect_to settings_path
  end
  
  private
    def dining_params
      params.require(:dining).permit!
    end
  
    def admin_user
      if logged_in?
        redirect_to current_user, flash: { danger: "Administrator permission required" } unless current_user.admin?
      else
        flash[:danger] = "Authorization failure"
        redirect_to root_url
      end
    end
end