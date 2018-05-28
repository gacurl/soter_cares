class LicenseTypesController < ApplicationController
  before_action :admin_user
  
  def update_multiple
    @licenses = LicenseType.update(params[:licenses].keys, params[:licenses].values)
    @licenses.reject! { |p| p.errors.empty? }
    flash[:success] = "License Types updated"
    redirect_to settings_path
  end
  
  def create
    LicenseType.create(license_params)
    flash[:success] = "License type created"
    redirect_to settings_path
  end
  
  def update
    LicenseType.find(params[:id]).update(license_params)
    flash[:success] = "License type updated"
    redirect_to settings_path
  end
  
  def destroy
    LicenseType.find(params[:id]).destroy
    flash[:success] = "License type deleted"
    redirect_to settings_path
  end
  
  private
    def license_params
      params.require(:license_type).permit!
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