class DiningsController < ApplicationController
  before_action :admin_user
  before_action :set_dining, except: [:index]

  def index
    @dinings = ActsAsTaggableOn::Tag.joins(:taggings).where(taggings: { context: 'dinings' }).distinct.order(name: :asc).paginate(page: params[:page], per_page: 50)
  end

  def edit

  end

  def update
    @dining.update(dinings_params)
    flash[:success] = "Dining updated"
    redirect_to dinings_path
  end

  def destroy
    @dining.destroy
    flash[:success] = "Dining deleted"
    redirect_to dinings_path
  end

  private
  def set_dining
    @dining = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def dinings_params
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