class CommunitiesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:destroy]
  before_action :set_community, only: [:show, :edit, :update, :new_note, :save_note,
                                        :add_clinician, :autocomplete_pharmacies,
                                        :destroy]
  
  def destroy
    if @community.patients.empty?
      @community.employees.update_all(community_id: nil)
      if @community.destroy
        redirect_to communities_path, flash: { success: "#{@community.name} successfully deleted." }
      else
        redirect_to communities_path, flash: { danger: "Something went wrong." }
      end
    else
      redirect_to communities_path, flash: { danger: "Unable to delete. #{@community.name} currently has residents assigned." }
    end
  end
  
  def autocomplete_pharmacies
    city = @community.zip_code.city
    @pharmacies = Pharmacy.all.search(params[:term])
        .near("#{city.name}, #{city.county.state.two_digit_code}", 200)
    @pharmacy_hash = []
    @pharmacies.each do |pharmacy|
        label = pharmacy.name
        
        if pharmacy.zip_code
            label << " - " + pharmacy.zip_code.city.name + ", " + pharmacy.zip_code.city.county.state.two_digit_code
        end
        @pharmacy_hash << { 
            label: label,
            value: pharmacy.id 
        }
    end
    
    render json: @pharmacy_hash
  end
  
  def autocomplete
    @communities = Community.search(params[:term])
    @community_hash = []
    @communities.each do |community|
        label = community.name
        if community.zip_code
          label << " - #{community.zip_code.city.name}, #{community.zip_code.city.county.state.two_digit_code}"
        else
          label << " - Unknown Address"
        end
        
        @community_hash << { 
            label: label,
            value: community.id 
        }
    end
    
    render json: @community_hash
  end
  
  def edit
    @community_activities = params[:id].present? ? Community.find(params[:id]).activities.map{|t| {id: t.id, name: t.name }} : []
    @community_dinings = params[:id].present? ? Community.find(params[:id]).dinings.map{|t| {id: t.id, name: t.name }} : []
    @community_features = params[:id].present? ? Community.find(params[:id]).features.map{|t| {id: t.id, name: t.name }} : []
    @community_undesireds = params[:id].present? ? Community.find(params[:id]).undesireds.map{|t| {id: t.id, name: t.name }} : []
    @community.open_since_input = @community.open_since.strftime("%m/%d/%Y") if @community.open_since
  end
  
  def show
    @data_file = DataFile.new
    @photo = Photo.new
  end
  
  def new
    @community = Community.new
  end
  
  def create
    @community = Community.new(community_params)
    @community.user = current_user
    if @community.save
      redirect_to @community
    else
      render 'new'
    end
  end
  
  def index
    search = params[:search] || nil
    distance = params[:distance] || nil
    city = City.find_by_id(params[:city_id])
    if distance.present? && city.present?
      @communities = Community.search(params[:search])
                      .near("#{city.name}, #{city.county.state.two_digit_code}", params[:distance].to_i)
                      .order(name: :asc).paginate(page: params[:page], :per_page => 50)
    elsif search.present?
      @communities = Community.search(params[:search])
                      .order(name: :asc).paginate(page: params[:page], :per_page => 50)
    else
      @communities = Community.order(name: :asc).paginate(page: params[:page], :per_page => 50)
    end
  end
  
  def update
    @community.assign_attributes(community_params)
    
    clinician = params[:community][:clinician_search]
    if clinician && clinician.split[0] == "New:"
      @community.clinicians << Contact.create(first_name: clinician.split(': ')[1].split[0], 
                                            last_name: clinician.split(': ')[1].split[1],
                                            contact_type: "Business")
    elsif params[:community][:clinician_id].present?
      @community.clinicians << Contact.find_by_id(params[:community][:clinician_id])
    end

    @community.nursing_director =  nil if params[:community].has_key?(:nursing_director) && params[:community][:nursing_director].blank?
    @community.executive_director = nil if params[:community].has_key?(:executive_director) && params[:community][:executive_director].blank?
    @community.admissions_director = nil if params[:community].has_key?(:admissions_director) && params[:community][:admissions_director].blank?
    @community.marketing_director = nil if params[:community].has_key?(:marketing_director) && params[:community][:marketing_director].blank?
    @community.zip_code = nil if params[:community].has_key?(:zip_code) && params[:community][:zip_code].blank?

    nursing_director =  params[:community][:nursing_director]
    executive_director = params[:community][:executive_director]
    admissions_director = params[:community][:admissions_director]
    marketing_director = params[:community][:marketing_director]
    if marketing_director && marketing_director.split[0] == "New:"
      @community.marketing_director = Contact.create(first_name: marketing_director.split(': ')[1].split[0], 
                                            last_name: marketing_director.split(': ')[1].split[1],
                                            contact_type: "Business",
                                            community: @community,
                                            company: @community.company,
                                            position: Position.find_by(title: "Marketing Director"),
                                            address_1: @community.address_1,
                                            address_2: @community.address_2,
                                            zip_code: @community.zip_code)
    end
    if nursing_director && nursing_director.split[0] == "New:"
      @community.nursing_director = Contact.create(first_name: nursing_director.split(': ')[1].split[0], 
                                            last_name: nursing_director.split(': ')[1].split[1],
                                            contact_type: "Business",
                                            community: @community,
                                            company: @community.company,
                                            position: Position.find_by(title: "Director of Nursing"),
                                            address_1: @community.address_1,
                                            address_2: @community.address_2,
                                            zip_code: @community.zip_code)
    end
    if admissions_director && admissions_director.split[0] == "New:"
      @community.admissions_director = Contact.create(first_name: admissions_director.split(': ')[1].split[0], 
                                            last_name: admissions_director.split(': ')[1].split[1],
                                            contact_type: "Business",
                                            community: @community,
                                            company: @community.company,
                                            position: Position.find_by(title: "Admissions Director"),
                                            address_1: @community.address_1,
                                            address_2: @community.address_2,
                                            zip_code: @community.zip_code)
    end
    if executive_director && executive_director.split[0] == "New:"
      @community.executive_director = Contact.create(first_name: executive_director.split(': ')[1].split[0], 
                                            last_name: executive_director.split(': ')[1].split[1],
                                            contact_type: "Business",
                                            community: @community,
                                            company: @community.company,
                                            position: Position.find_by(title: "Executive Director"),
                                            address_1: @community.address_1,
                                            address_2: @community.address_2,
                                            zip_code: @community.zip_code)
    end
    
    if @community.private_availability
      @community.availabilities << Availability.new(capacity_type: "Private", 
                  number_available: @community.private_availability)
    end
    if @community.semi_private_availability
      @community.availabilities << Availability.new(capacity_type: "Semi-Private", 
                  number_available: @community.semi_private_availability)
    end
      
    @community.open_since = Date.strptime(@community.open_since_input,  "%m/%d/%Y") unless @community.open_since_input.blank?
    @data_file = DataFile.new
    @photo = Photo.new
    @community.save
  end
  
  def activities
    activities = TaggingManual.tokens('activities', params[:q])
    respond_to do |format|
      format.json { render json: activities }
    end
  end
  
  def dinings
    dinings = TaggingManual.tokens('dinings', params[:q])
    respond_to do |format|
      format.json { render json: dinings }
    end
  end
  
  def features
    features = TaggingManual.tokens('features', params[:q])
    respond_to do |format|
      format.json { render json: features }
    end
  end
  
  def undesireds
    undesireds = TaggingManual.tokens('undesireds', params[:q])
    respond_to do |format|
      format.json { render json: undesireds }
    end
  end
  
  def new_note
    @note = Note.new
  end
  
  def save_note
    @note = Note.new(note_params)
    @note.user = current_user
    @community.notes << @note
    @data_file = DataFile.new
    @photo = Photo.new
    respond_to do |format|
      format.html
      format.js { render 'update.js.erb' }
    end
  end
  
  private
    def community_params
      list_params_allowed = [:company_id, :executive_director_id, :nursing_director_id,
          :name, :address_1, :address_2, :zip, :open_since_input, :semi_private_capacity,
          :semi_private, :private_capacity, :private, :community_fee, :second_person_fee,
          :respite_rate, :adult_day_care_rate, :pets, :admissions_director_id,
          :marketing_director_id, :youtube_identifier,
          :pharmacy_id, :transport, :zip_code_id, :activity_list_tokens,
          :dining_list_tokens, :feature_list_tokens, :undesired_list_tokens,
          :phone_number, :fax, :al_license, :company_id, :website, :average_age,
          :private_availability, :semi_private_availability, :clinician_id, :clinician_search, :price_notes,
          :license_type_ids => [], :medicaid_provider_ids => []]
          
      list_params_allowed << :user_id if current_user.admin?
      params.require(:community).permit(list_params_allowed)
    end
    
    def note_params
      params.require(:note).permit(:content)
    end
    
    def logged_in_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless logged_in?
    end
  
    def set_community
      @community = Community.find_by_id(params[:id]) || Community.find_by_id(params[:community_id])
    end
    
    def admin_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless current_user.admin?
    end
  
end