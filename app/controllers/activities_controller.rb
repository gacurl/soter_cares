class ActivitiesController < ApplicationController
  before_action :admin_user
  
  def update_multiple
    @activities = Activity.update(params[:activities].keys, params[:activities].values)
    @activities.reject! { |p| p.errors.empty? }
    flash[:success] = "Activities updated"
    redirect_to settings_path
  end
  
  def create
    Activity.create(activities_params)
    flash[:success] = "Activity created"
    redirect_to settings_path
  end
  
  def update
    Activity.find(params[:id]).update(activities_params)
    flash[:success] = "Activity updated"
    redirect_to settings_path
  end
  
  def destroy
    Activity.find(params[:id]).destroy
    flash[:success] = "Activity deleted"
    redirect_to settings_path
  end
  
  private
    def activities_params
      params.require(:activity).permit!
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