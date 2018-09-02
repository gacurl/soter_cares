class StaticPagesController < ApplicationController
  before_action :admin_user, only: [:settings]
  
  def home
    if session[:city].present?
      @city = session[:city]
    else
      results = Geocoder.search(remote_ip())
      @city = results.first.city + ', ' + results.first.region_code
    end

    if logged_in?
      redirect_to current_user
    end
  end

  def privacy
  end

  def terms
  end

  def team
  end

  def testimonials
  end

  def settings
    @activities = Activity.all
    @activity = Activity.new
    @dinings = Dining.all
    @dining = Dining.new
    @features = Feature.all
    @feature = Feature.new
    @licenses = LicenseType.all
    @license = LicenseType.new
    @results = ResultType.all
    @result = ResultType.new
    @providers = MedicaidProvider.all
    @provider = MedicaidProvider.new
    @positions = Position.all
    @position = Position.new
    @statuses = PlacementStatus.all
    @status = PlacementStatus.new
    @users = User.all
    @new_user = User.new
  end
  
  private
    def admin_user
      if logged_in?
        redirect_to current_user, flash: { danger: "Administrator permission required" } unless current_user.admin?
      else
        flash[:danger] = "Authorization failure"
        redirect_to root_url
      end
    end
end