class FeaturesController < ApplicationController
  before_action :admin_user
  
  def update_multiple
    @features = Feature.update(params[:features].keys, params[:features].values)
    @features.reject! { |p| p.errors.empty? }
    flash[:success] = "Features updated"
    redirect_to settings_path
  end
  
  def create
    Feature.create(features_params)
    flash[:success] = "Feature created"
    redirect_to settings_path
  end
  
  def update
    Feature.find(params[:id]).update(features_params)
    flash[:success] = "Feature updated"
    redirect_to settings_path
  end
  
  def destroy
    Feature.find(params[:id]).destroy
    flash[:success] = "Feature deleted"
    redirect_to settings_path
  end
  
  private
    def features_params
      params.require(:feature).permit!
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