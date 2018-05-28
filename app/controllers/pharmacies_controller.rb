class PharmaciesController < ApplicationController
  before_action :logged_in_user
  before_action :set_pharmacy, only: [:show, :edit, :update, :new_note, :save_note, :destroy]
  
  def destroy
    @pharmacy.destroy
    flash[:success] = "Pharmacy destroyed"
    redirect_to pharmacies_path
  end
  
  def new
    @pharmacy = Pharmacy.new
  end
  
  def create
    @pharmacy = Pharmacy.create(pharmacy_params)
    redirect_to @pharmacy
  end
  
  def edit
  end
  
  def update
    @pharmacy.update(pharmacy_params)
  end
  
  def index
    if params[:city_id]
      city = City.find_by_id(params[:city_id])
      @pharmacies = Pharmacy.near("#{city.name}, #{city.county.state.two_digit_code}", params[:distance].to_i).paginate(page: params[:page], :per_page => 50)
    else
      @pharmacies = Pharmacy.paginate(page: params[:page], :per_page => 50)
    end
   
  end
  
  def show
  end
  
  def new_note
    @note = Note.new
  end
  
  def save_note
    @note = Note.new(note_params)
    @note.user = current_user
    @pharmacy.notes << @note
    respond_to do |format|
      format.html
      format.js { render 'update.js.erb' }
    end
  end
  
  private
    def pharmacy_params
      list_params_allowed = [:pharmacy_id,
          :name, :address_1, :address_2, :zip, :zip_code_id,
          :phone_number, :fax, :website, :community_id, :email]
          
      list_params_allowed << :user_id if current_user.admin?
      params.require(:pharmacy).permit(list_params_allowed)
    end
    
    def note_params
      params.require(:note).permit(:content)
    end
    
    def logged_in_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless logged_in?
    end
    
    def set_pharmacy
      @pharmacy = Pharmacy.find_by_id(params[:id]) || Pharmacy.find_by_id(params[:pharmacy_id])
    end
end