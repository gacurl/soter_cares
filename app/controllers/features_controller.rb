class FeaturesController < ApplicationController
  before_action :admin_user
  before_action :set_feature, except: [:index]

  def index
    @features = ActsAsTaggableOn::Tag.joins(:taggings).where(taggings: { context: 'features' }).distinct.order(name: :asc).paginate(page: params[:page], per_page: 50)
  end

  def edit

  end

  def update
    @feature.update(features_params)
    flash[:success] = "Feature updated"
    redirect_to features_path
  end

  def destroy
    @feature.destroy
    flash[:success] = "Feature deleted"
    redirect_to features_path
  end

  private
  def set_feature
    @feature = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def features_params
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