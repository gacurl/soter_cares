class UsersController < ApplicationController
  before_action :admin_user,     only: [:index, :edit, :new, :create, :update,
                                        :resend_activation_email, :update_multiple]
  
   before_action :correct_user, except: [:index, :edit, :new, :create, :update,
                                        :resend_activation_email, :update_multiple]
  
  def update_multiple
    @users = User.update(params[:users].keys, params[:users].values)
    @users.reject! { |p| p.errors.empty? }
    flash[:success] = "Users updated"
    redirect_to settings_path
  end
  
  def password
    
  end
  
  def update_password
    if logged_in?
      @user == current_user
    else
      redirect_to root_url
    end
    
    @user.attributes = password_params
    
    if @user.changed?
        change = true
    end
   
    if @user.save
      if change == true
        flash[:success] = "Password updated"
      else
        flash[:info] = "Password remains the same"
      end
      redirect_to @user
    else
      render 'password'
    end
  end
  
  def new
     @user = User.new
  end
  
  def resend_activation_email
    user = User.find_by_id(params[:user_id])
    user.create_activation_digest
    user.save
    user.send_activation_email
    flash[:success] =  "Activation email resent to user."
    redirect_to users_path
  end
  
  def create
    @user = User.new(user_params)
    @user.disable = false
    @user.password = SecureRandom.base64(13)
    if @user.save
      @user.send_activation_email
      flash[:success] =  "User created. Activation email sent to new user."
      redirect_to settings_path
    else
      render 'new'
    end
  end
  
  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] =  "User updated."
      redirect_to settings_path
    end
  end
  
  def show
    if @user.admin?
      @leads = Contact.joins(:results)
                .where('results.updated_at = (SELECT MAX(results.updated_at) FROM results WHERE results.contact_id = contacts.id)')
                .where('results.result_type_id = ?', ResultType.find_by(name: "Qualified, OK to pursue").id)
                .order('results.created_at DESC')
                .joins(:placement_status)
                .where.not(placement_statuses: { status: "Placed" })
                .paginate(page: params[:lead_page], :per_page => 25)
      @notes = Note.all.order(created_at: :desc).paginate(page: params[:notes_page], :per_page => 25)
      @recent_placements = Contact.joins(:results)
                          .where(results: { result_type: ResultType.where('name = ? OR name = ?', "Placed Semi-Private", "Placed Private") })
                          .where('contacts.placement > ?', 60.days.ago)
                          .order('contacts.placement DESC')
                          .distinct
                          .paginate(page: params[:recent_placement_page], :per_page => 25)
    else
      @leads = Contact.where(user: current_user).joins(:results).joins(:placement_status)
                .where('results.updated_at = (SELECT MAX(results.updated_at) FROM results WHERE results.contact_id = contacts.id)')
                .where('results.result_type_id = ?', ResultType.find_or_create_by(name: "Qualified, OK to pursue").id)
                .joins(:placement_status)
                .where.not(placement_statuses: { status: "Placed" })
                .paginate(page: params[:lead_page], :per_page => 25)
      @notes = @user.notes.order(created_at: :desc).paginate(page: params[:notes_page], :per_page => 25)
      @recent_placements = Contact.where(user: current_user).joins(:results)
                          .where(results: { result_type: ResultType.where('name = ? OR name = ?', "Placed Semi-Private", "Placed Private") })
                          .where('contacts.placement > ?', 60.days.ago)
                          .order('contacts.placement DESC')
                          .distinct
                          .paginate(page: params[:recent_placement_page], :per_page => 25)
    end
    @near_placements = Contact.where('placement <= ? AND placement >= ?', 30.days.from_now, Date.today)
                        .joins(:results)
                        .where('results.updated_at = (SELECT MAX(results.updated_at) FROM results WHERE results.contact_id = contacts.id)')
                        .where('results.result_type_id = ?', ResultType.find_by(name: "Qualified, OK to pursue").id)
                        .order('contacts.placement ASC')
                        .joins(:placement_status)
                        .where.not(placement_statuses: { status: "Placed" })
                        .paginate(page: params[:placement_page], :per_page => 25)
    
    
                        
  end
  
  def index
    @users = User.all.paginate(per_page: 50, page: params[:page])
  end
  
  def edit
    @user = User.find_by_id(params[:id])
    if @user.nil?
      @user = current_user
    end
  end
  
  private
    def correct_user
      if params[:id].present?
        @user = User.find(params[:id])
      elsif params[:user_id].present?
        @user = User.find(params[:user_id])
      end
      
      if logged_in?
        redirect_to(current_user) unless current_user?(@user)
      else
        flash[:info] = "Your session expired. Please login again."
        redirect_to root_url
      end
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :admin, 
                                    :disable, :profile, :pic_link)
    end
    
    def password_params
      params.require(:user).permit(:id, :password, :password_confirmation)
    end
    
    def mass_params
      params.require(:users).permit(:id, :name, :email, :admin, :disable)
    end 
    
    # Confirms an admin user.
    def admin_user
      if logged_in?
        redirect_to(root_url) unless current_user.admin?
      else
        flash[:info] = "Your session expired. Please login again."
        redirect_to root_url
      end
    end
    
end
