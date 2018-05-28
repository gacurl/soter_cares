class CompaniesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:destroy]
  before_action :set_company, only: [:show, :edit, :update, :new_note, :save_note,
                                :destroy]
  
  def destroy
    if @company.invoices.empty? && @company.payments.empty?
      @company.contacts.update_all(company_id: nil)
      @company.communities.update_all(company_id: nil)
      if @company.delete
        redirect_to companies_path, flash: { success: "#{@company.name} successfully deleted." }
      else
        redirect_to companies_path, flash: { danger: "Something went wrong." }
      end
    else
      redirect_to companies_path, flash: { danger: "Unable to delete #{@community.name}. Please delete all invoices, payments, and phramcies and try again." }
    end
  end
  
  def autocomplete
    @companies = Company.search(params[:term])
    @company_hash = []
    @companies.each do |company|
        label = company.name
        if company.zip_code
          label << " - #{company.zip_code.city.name}, #{company.zip_code.city.county.state.two_digit_code}"
        else
          label << " - Unknown Address"
        end
        
        @company_hash << { 
            label: label,
            value: company.id 
        }
    end
    
    render json: @company_hash
  end
  
  def new
    @company = Company.new
  end
  
  def create
    @company = Company.new(company_params)
    @company.user = current_user
    if @company.save
      redirect_to @company
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    @company.update(company_params)
    @data_file = DataFile.new
    if params[:company][:community_id].present?
      @company.communities << Community.find_by_id(params[:company][:community_id])
    end
  end
  
  def show
    @data_file = DataFile.new
  end
  
  def index
    search = params[:search] || nil
    if search
      @companies = Company.search(params[:search]).order(name: :asc).paginate(page: params[:page], :per_page => 50)
    else
      @companies = Company.order(name: :asc).paginate(page: params[:page], :per_page => 50)
    end
  end
  
  def new_note
    @note = Note.new
  end
  
  def save_note
    @note = Note.new(note_params)
    @note.user = current_user
    @company.notes << @note
    @data_file = DataFile.new
    respond_to do |format|
      format.html
      format.js { render 'update.js.erb' }
    end
  end
  
  private
    def company_params
      list_params_allowed = [:company_id,
          :name, :address_1, :address_2, :zip, :zip_code_id, 
          :phone_number, :fax, :community_id, :website]
          
      list_params_allowed << :user_id if current_user.admin?
      params.require(:company).permit(list_params_allowed)
    end
    
    def note_params
      params.require(:note).permit(:content)
    end
    
    def logged_in_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless logged_in?
    end
  
    def set_company
      @company = Company.find_by_id(params[:id]) || Company.find_by_id(params[:company_id])
    end
    
    def admin_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless current_user.admin?
    end
end