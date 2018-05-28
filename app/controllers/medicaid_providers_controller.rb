class MedicaidProvidersController < ApplicationController
  before_action :admin_user
  
  def update_multiple
    @providers = MedicaidProvider.update(params[:medicaid_providers].keys, params[:medicaid_providers].values)
    @providers.reject! { |p| p.errors.empty? }
    flash[:success] = "Medicaid Providers updated"
    redirect_to settings_path
  end
  
  
  def create
    MedicaidProvider.create(status_params)
    flash[:success] = "Medicaid Provider created"
    redirect_to settings_path
  end
  
  def update
    MedicaidProvider.find(params[:id]).update(status_params)
    flash[:success] = "Medicaid Provider updated"
    redirect_to settings_path
  end
  
  def destroy
    MedicaidProvider.find(params[:id]).destroy
    flash[:success] = "Medicaid Provider deleted"
    redirect_to settings_path
  end
  
  private
    def status_params
      params.require(:medicaid_provider).permit!
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