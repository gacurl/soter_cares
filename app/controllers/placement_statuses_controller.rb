class PlacementStatusesController < ApplicationController
  before_action :admin_user
  
  def update_multiple
    @statuses = PlacementStatus.update(params[:placement_statuses].keys, params[:placement_statuses].values)
    @statuses.reject! { |p| p.errors.empty? }
    flash[:success] = "Placement Statuses updated"
    redirect_to settings_path
  end
  
  
  def create
    PlacementStatus.create(status_params)
    flash[:success] = "Placement Status created"
    redirect_to settings_path
  end
  
  def update
    PlacementStatus.find(params[:id]).update(status_params)
    flash[:success] = "Placement Status updated"
    redirect_to settings_path
  end
  
  def destroy
    PlacementStatus.find(params[:id]).destroy
    flash[:success] = "Placement Status deleted"
    redirect_to settings_path
  end
  
  private
    def status_params
      params.require(:placement_status).permit!
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