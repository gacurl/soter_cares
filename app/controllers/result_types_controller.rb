class ResultTypesController < ApplicationController
  before_action :admin_user
  
  def update_multiple
    @results = ResultType.update(params[:results].keys, params[:results].values)
    @results.reject! { |p| p.errors.empty? }
    flash[:success] = "Results updated"
    redirect_to settings_path
  end
  
  def create
    ResultType.create(result_params)
    flash[:success] = "Result type created"
    redirect_to settings_path
  end
  
  def update
    ResultType.find(params[:id]).update(result_params)
    flash[:success] = "Result type updated"
    redirect_to settings_path
  end
  
  def destroy
    ResultType.find(params[:id]).destroy
    flash[:success] = "Result type deleted"
    redirect_to settings_path
  end
  
  private
    def result_params
      params.require(:result_type).permit!
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