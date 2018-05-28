class PositionsController < ApplicationController
  before_action :admin_user
  
  def update_multiple
    @positions = Position.update(params[:positions].keys, params[:positions].values)
    @positions.reject! { |p| p.errors.empty? }
    flash[:success] = "Positions updated"
    redirect_to settings_path
  end
  
  def create
    Position.create(position_params)
    flash[:success] = "Position type created"
    redirect_to settings_path
  end
  
  def update
    Position.find(params[:id]).update(position_params)
    flash[:success] = "Position type updated"
    redirect_to settings_path
  end
  
  def destroy
    Position.find(params[:id]).destroy
    flash[:success] = "Position type deleted"
    redirect_to settings_path
  end
  
  private
    def position_params
      params.require(:position).permit!
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