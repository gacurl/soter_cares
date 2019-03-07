class ActivitiesController < ApplicationController
  before_action :admin_user
  before_action :set_activity, except: [:index]
  
  def update_multiple
    @activities = Activity.update(params[:activities].keys, params[:activities].values)
    @activities.reject! { |p| p.errors.empty? }
    flash[:success] = "Activities updated"
    redirect_to settings_path
  end

  def index
    @activities = ActsAsTaggableOn::Tag.joins(:taggings).where(taggings: { context: 'activities' }).distinct.order(name: :asc).paginate(page: params[:page], per_page: 50)
  end

  def edit

  end

  def update
    @activity.update(activities_params)
    flash[:success] = "Activity updated"
    redirect_to activities_path
  end
  
  def destroy
    @activity.destroy
    flash[:success] = "Activity deleted"
    redirect_to activities_path
  end
  
  private
    def set_activity
      @activity = ActsAsTaggableOn::Tag.find(params[:id])
    end

    def activities_params
      params.require(:acts_as_taggable_on_tag).permit(:name)
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