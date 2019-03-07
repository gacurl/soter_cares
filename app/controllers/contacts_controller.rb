class ContactsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:destroy]
  before_action :set_contact, only: [:show, :edit, :update, :destroy, 
                  :new_note, :save_note, :decision_makers,
                  :update_decision_makers, :add_family,
                  :new_result, :save_result, :new_respite, :save_respite, :edit_result, :edit_finance,
                  :save_finance, :community_search, :distance_search,
                  :update_prospective_communities, :destroy_prospective_communities, 
                  :upload_data_file]

  def upload_data_file
    @data_file = @contact.data_files.new(data_file_params)
    respond_to do |format|
      if @data_file.save
        format.html { redirect_to @data_file, notice: 'File was successfully created.' }
        format.json { render :show, status: :created, location: [@contact, @data_file] }
      else
        format.html { render :new }
        format.json { render json: @data_file.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def destroy
    if @contact.destroy
      flash[:success] = "Contact destroyed."
      redirect_to contacts_path
    end
  end


  def update_prospective_communities
    @contact.prospects << Community.find_by_id(params[:community_id])
  end 
  
  def destroy_prospective_communities
    @contact.prospects.delete(Community.find_by_id(params[:community_id]))
    respond_to do |format|
      format.js { render 'update_prospective_communities.js.erb' }
    end
  end  
  
  def distance_search
    city = City.find_by_id(params[:city_id])
    if city
      if @contact.license_list.present?
        license_ids = LicenseType.tagged_with(@contact.license_list, on: :licenses, any: true).pluck(:id)
        @communities = Community.with_licenses(license_ids).near("#{city.name}, #{city.county.state.two_digit_code}", params[:distance].to_i)
      else
        @communities = Community.near("#{city.name}, #{city.county.state.two_digit_code}", params[:distance].to_i)
      end
      tags = @contact.dining_list + @contact.activity_list + @contact.feature_list + @contact.undesired_list
      @communities = @communities.sort_by { |o| -(tags & (o.dining_list + o.activity_list + o.feature_list + o.undesired_list)).length }
    else
      @communities = Community.search(params[:name])
    end
  #  @activities = Community.tag_counts_on(:activities)
  end
  
  def autocomplete
    @contacts = Contact.all.search(params[:term])
    @contact_hash = []
    @contacts.each do |contact|
        label = contact.last_name
        label << ", " if contact.first_name
        label << contact.first_name if contact.first_name
        if contact.dob
          label << " - " + contact.dob.strftime("%m/%d/%Y")
        end
        if contact.community
          label << " - " + contact.community.name 
          if contact.community.zip_code
            label << " - " + contact.community.zip_code.city.name + ", " 
                    + contact.community.zip_code.city.county.state.two_digit_code
          end
        end
        if contact.zip_code
          label << " - " + contact.zip_code.city.name + ", " + 
                    contact.zip_code.city.county.state.two_digit_code
        end
        @contact_hash << { 
            label: label,
            value: contact.id 
        }
    end
    
    render json: @contact_hash
  end
  
  def autocomplete_resident
    @contacts = Contact.where(contact_type: "Resident").search(params[:term])
    @contact_hash = []
    @contacts.each do |contact|
        label = contact.last_name
        label << ", " if contact.first_name
        label << contact.first_name if contact.first_name
        if contact.dob
          label << " - " + contact.dob.strftime("%m/%d/%Y")
        end
        if contact.community
          label << " - " + contact.community.name 
          if contact.community.zip_code
            label << " - " + contact.community.zip_code.city.name + ", " 
                    + contact.community.zip_code.city.county.state.two_digit_code
          end
        end
        if contact.zip_code
          label << " - " + contact.zip_code.city.name + ", " + 
                    contact.zip_code.city.county.state.two_digit_code
        end
        @contact_hash << { 
            label: label,
            value: contact.id 
        }
    end
    
    render json: @contact_hash
  end
  
  def autocomplete_family
    @contacts = Contact.search(params[:term])
    @contact_hash = []
    @contacts.each do |contact|
        label = contact.last_name
        label << ", " if contact.first_name
        label << contact.first_name if contact.first_name
        
        if contact.zip_code
          label << " - " + contact.zip_code.city.name + ", " + 
                    contact.zip_code.city.county.state.two_digit_code
        end
        @contact_hash << { 
            label: label,
            value: contact.id ,
            gender: contact.gender
        }
    end
    
    render json: @contact_hash
  end
  
  def autocomplete_business
    @contacts = Contact.where(contact_type: "Business").search(params[:term])
    @contact_hash = []
    
    @contact_hash << { 
              label: "New: " + params[:term],
              value: "<<<#{params[:term]}>>>"
          }
          
    @contacts.each do |contact|
        label = contact.last_name
        label << ", " if contact.first_name
        label << contact.first_name if contact.first_name
        
        @contact_hash << { 
            label: label,
            value: contact.id
        }
    end
    
    render json: @contact_hash
  end
  
  def autocomplete_clinician
    @contacts = Contact.where(contact_type: "Business").joins(:position)
                  .where(positions: {clinician: true}).search(params[:term])
    @contact_hash = []
    
    @contact_hash << { 
              label: "New: " + params[:term],
              value: "<<<#{params[:term]}>>>"
          }
          
    @contacts.each do |contact|
        label = contact.last_name
        label << ", " if contact.first_name
        label << contact.first_name if contact.first_name
        label << " - " + contact.position.title
        
        @contact_hash << { 
            label: label,
            value: contact.id
        }
    end
    
    render json: @contact_hash
  end
  
  def new
    if params[:contact]
      @contact = Contact.new(contact_params)
    else
      @contact = Contact.new
    end
    @zip_codes = ZipCode.search(params[:search])
  end
  
  def create
    if params[:contact][:company_id].present?
      company = Company.find_by_id(params[:contact][:company_id])
    elsif params[:contact][:company].present?
      company = Company.new(name: params[:contact][:company])
    end
    
    if params[:contact][:community_id].present?
      community = Community.find_by_id(params[:contact][:community_id])
    elsif params[:contact][:community].present?
      community = Community.new(name: params[:contact][:community])
    end
    
    @contact = Contact.new(contact_params)
    if @contact.gender == "Male"
      @contact.salutation = params[:contact][:salutation_male]
    elsif @contact.gender == "Female"
      @contact.salutation = params[:contact][:salutation_female]
    end
    if @contact.contact_type == "Resident"
      @contact.dob = Date.strptime(@contact.dob_input,  "%m/%d/%Y") unless @contact.dob_input.blank?
      @contact.pay_entry_base_date= Date.strptime(@contact.pay_entry_base_date_input,  "%m/%d/%Y") unless @contact.pay_entry_base_date_input.blank?
      @contact.end_of_active_service = Date.strptime(@contact.end_of_active_service_input,  "%m/%d/%Y") unless @contact.end_of_active_service_input.blank?
      @contact.benefit_received = Date.strptime(@contact.benefit_received_input,  "%m/%d/%Y") unless @contact.benefit_received_input.blank?
      @contact.va_application_submitted = Date.strptime(@contact.va_application_submitted_input,  "%m/%d/%Y") unless @contact.va_application_submitted_input.blank?
      @contact.placement = Date.strptime(@contact.placement_input,  "%m/%d/%Y") unless @contact.placement_input.blank?
      @contact.finance = Finance.create
    end
    @contact.zip_code = ZipCode.find_by_id(params[:contact][:zip_code_id])
    @contact.company = company
    @contact.community = community
    
    if community.present? && company.present? &&
          community.new_record?
      community.company = company
    end
    
    @contact.user = current_user
    
    if community && community.new_record?
      community.user = @contact.user
    end
    
    if params[:copy_community] == "1" && community.new_record?
      community.address_1 = @contact.address_1
      community.address_2 = @contact.address_2
      community.zip_code = @contact.zip_code
    end
    
    if params[:copy_company] == "1" && company.new_record?
      company.address_1 = @contact.address_1
      company.address_2 = @contact.address_2
      company.zip_code = @contact.zip_code
    end
    
    
    
    if @contact.save
      @contact.company.save if @contact.company
      @contact.community.save if @contact.community
      
      flash[:success] = "Contact created"
      
      if @contact.resident_search.present?
        input =  @contact.resident_search
        relation = Contact.find_by_id(@contact.relation_id) || Contact.new
        if relation.new_record?
          relation.last_name = input.split(' ').last
          relation.first_name = input.split(' ').first
          relation.contact_type = "Resident"
          relation.user = current_user
        end
        relationship = Relationship.new
        if @contact.gender == "Male"
          relationship.step = params[:step]
          relationship.great = params[:great]
          relationship.in_law = params[:in_law]
          relationship.relationship_type = RelationshipType.find_by_id(params[:contact][:male_relationship_type])
        elsif @contact.gender == "Female"
          relationship.step = params[:step]
          relationship.great = params[:great]
          relationship.in_law = params[:in_law]
          relationship.relationship_type = RelationshipType.find_by_id(params[:contact][:female_relationship_type])
        end
        relationship.relation = relation
        @contact.relationships << relationship
       # if @contact.hierarchy.present?
       #   decision = DecisionMaker.find_or_create_by(contact_id: relation.id, hierarchy: @contact.hierarchy)
       #   decision.relationship = Relationship.find_by(contact: relation, relation: @contact)
       #   relation.decision_makers << decision
       # end
        redirect_to relation
      else
        redirect_to @contact  
      end
      
    else
      render :new
    end
  end
  
  def index
    search = params[:search] || nil
    if search.present?
      if params[:contact_type].present?
        case params[:contact_type]
        when 'Prospect'
          @contacts = Contact.where(contact_type: "Resident").search(search)
                           .where.not(deceased: true, placement_status_id: PlacementStatus.find_by(status: "Placed"))
                           .order(last_name: :asc)
                           .paginate(page: params[:prospect_page], :per_page => 50)
        when 'Family'
          @contacts = Contact.where(contact_type: "Family").search(search)
                        .order(last_name: :asc).paginate(page: params[:family_page], :per_page => 50)
        when 'Resident'
          @contacts = Contact.where(contact_type: "Resident").search(search)
                           .where.not(deceased: true).where(placement_status_id: PlacementStatus.find_by(status: "Placed"))
                           .order(last_name: :asc)
                           .paginate(page: params[:resident_page], :per_page => 50)
        when 'Business'
          @contacts = Contact.where(contact_type: "Business").search(search)
                            .order(last_name: :asc).paginate(page: params[:business_page], :per_page => 50)
        else
          @contacts = Contact.search(search).order(last_name: :asc).paginate(page: params[:contact_page], :per_page => 50)
        end
      else
        @contacts = Contact.search(search).order(last_name: :asc).paginate(page: params[:contact_page], :per_page => 50)
      end
    else
      if params[:contact_type].present?
        case params[:contact_type]
        when 'All'
          @contacts = Contact.order(last_name: :asc).paginate(page: params[:contact_page], :per_page => 50)
        when 'Prospect'
          @contacts = Contact.where(contact_type: "Resident")
                           .where.not(deceased: true, placement_status_id: PlacementStatus.find_by(status: "Placed"))
                           .order(last_name: :asc)
                           .paginate(page: params[:prospect_page], :per_page => 50)
        when 'Family'
          @contacts = Contact.where(contact_type: "Family")
                        .order(last_name: :asc).paginate(page: params[:family_page], :per_page => 50)
        when 'Resident'
          @contacts = Contact.where(contact_type: "Resident")
                           .where.not(deceased: true).where(placement_status_id: PlacementStatus.find_by(status: "Placed"))
                           .order(last_name: :asc)
                           .paginate(page: params[:resident_page], :per_page => 50)
        when 'Business'
          @contacts = Contact.where(contact_type: "Business")
                            .order(last_name: :asc).paginate(page: params[:business_page], :per_page => 50)
        end
      else
        @contacts = Contact.order(last_name: :asc).paginate(page: params[:contact_page], :per_page => 50)
      end
    end
  end
  
  def edit
    @contact_activities = params[:id].present? ? Contact.find(params[:id]).activities.map{|t| {id: t.id, name: t.name }} : []
    @contact_dinings = params[:id].present? ? Contact.find(params[:id]).dinings.map{|t| {id: t.id, name: t.name }} : []
    @contact_features = params[:id].present? ? Contact.find(params[:id]).features.map{|t| {id: t.id, name: t.name }} : []
    @contact_undesireds = params[:id].present? ? Contact.find(params[:id]).undesireds.map{|t| {id: t.id, name: t.name }} : []
    @contact_licenses = params[:id].present? ? Contact.find(params[:id]).licenses.map{|t| {id: t.id, name: t.name }} : []
  end
  
  def show
    @communities = []
    @data_file = DataFile.new
  end
  
  def update
    @contact.assign_attributes(contact_params)
    @contact.dob = Date.strptime(@contact.dob_input,  "%m/%d/%Y") unless @contact.dob_input.blank?
    @contact.pay_entry_base_date= Date.strptime(@contact.pay_entry_base_date_input,  "%m/%d/%Y") unless @contact.pay_entry_base_date_input.blank?
    @contact.end_of_active_service = Date.strptime(@contact.end_of_active_service_input,  "%m/%d/%Y") unless @contact.end_of_active_service_input.blank?
    @contact.va_application_submitted = Date.strptime(@contact.va_application_submitted_input,  "%m/%d/%Y") unless @contact.va_application_submitted_input.blank?
    @contact.benefit_received = Date.strptime(@contact.benefit_received_input,  "%m/%d/%Y") unless @contact.benefit_received_input.blank?
    @contact.placement = Date.strptime(@contact.placement_input,  "%m/%d/%Y") unless @contact.placement_input.blank?
    @contact.clinics << Community.find_by_id(params[:contact][:clinic_id]) unless params[:contact][:clinic_id].blank?
    @contact.case_manager_check
    @contact.save
    @data_file = DataFile.new
    @communities = []
    respond_to do |format|
      format.html
      format.js { render 'update.js.erb' }
    end
  end
  
  def add_family
    relation = Contact.find_by_id(params[:contact][:relation_id])
    relationship = Relationship.new
    relationship.contact = @contact
    relationship.relation = relation
    if relation.gender == "Male"
      relationship.relationship_type = RelationshipType.find_by_id(params[:contact][:male_relationship_type])
    elsif relation.gender == "Female"
      relationship.relationship_type = RelationshipType.find_by_id(params[:contact][:female_relationship_type])
    end
    relationship.save
    @data_file = DataFile.new
    respond_to do |format|
      format.html
      format.js { render 'add_family.js.erb' }
    end
  end
  
  def new_note
    @note = Note.new
  end
  
  def save_note
    @note = Note.new(note_params)
    @note.user = current_user
    @contact.notes << @note
    @data_file = DataFile.new
    respond_to do |format|
      format.html
      format.js { render 'update.js.erb' }
    end
  end
  
  def new_result
    @result = Result.new
  end
  
  def new_respite
    @respite = RespiteStay.new
  end
  
  def save_respite
    @respite = RespiteStay.new(respite_params)
    @respite.start = Date.strptime(respite_params[:start], "%m/%d/%Y") if respite_params[:start]
    @respite.stop = Date.strptime(respite_params[:stop], "%m/%d/%Y") if respite_params[:stop]
    @respite.fee = @respite.community.respite_rate
    @contact.respite_stays << @respite
    @data_file = DataFile.new
    render 'update.js.erb'
  end
  
  def edit_result
    @result = Result.find_by_id(params[:result_id])
  end
  
  def save_result
    refresh = false
    @result = Result.find_by_id(params[:result][:result_id])
    if @result
      @result.update(result_params) if @result.persisted?
    else
      @result = Result.new(result_params)
    end
    @result.contact = @contact
    
    @result.updated_at = Date.strptime(result_params[:updated_at], "%m/%d/%Y") if result_params[:updated_at]
    
    case @result.result_type.name
    when "Placed Private"
      if @contact.facility
        last_placement = @contact.results.where('result_type_id = ? OR result_type_id = ?', 
                          ResultType.find_by(name: "Placed Private"), 
                          ResultType.find_by(name: "Placed Semi-Private")).last
        
        if @contact.facility.availabilities.any?
          last_availability = @contact.facility.availabilities.where(capacity_type: last_placement.result_type.name.split[1]).last
          @contact.facility.availabilities << Availability.new(capacity_type: last_availability.capacity_type,
                        number_available:  @contact.facility.availabilities
                                            .where(capacity_type: last_availability.capacity_type).last.number_available + 1)
        end
      end
      
      @contact.facility = @result.community
      @contact.placement_status = PlacementStatus.find_by(status: "Placed")
      if @contact.facility.availabilities.any?
        @contact.facility.availabilities << Availability.new(capacity_type: "Private",
                        number_available: @contact.facility.availabilities
                            .where(capacity_type: "Private").last.number_available - 1)
      end
    when "Placed Semi-Private"
      if @contact.facility
        last_placement = @contact.results.where('result_type_id = ? OR result_type_id = ?', 
                          ResultType.find_by(name: "Placed Private"), 
                          ResultType.find_by(name: "Placed Semi-Private")).last
        
        p last_placement.result_type.name.split[1]
        
        if @contact.facility.availabilities.any?
          last_availability = @contact.facility.availabilities.where(capacity_type: last_placement.result_type.name.split[1]).last
          @contact.facility.availabilities << Availability.new(capacity_type: last_availability.capacity_type,
                        number_available:  @contact.facility.availabilities
                                            .where(capacity_type: last_availability.capacity_type).last.number_available + 1)
        end
      end
 
      @contact.facility = @result.community
      @contact.placement_status = PlacementStatus.find_by(status: "Placed")
      if @contact.facility.availabilities.any?
        @contact.facility.availabilities << Availability.new(capacity_type: "Semi-Private",
                        number_available: @contact.facility.availabilities.where(capacity_type: "Semi-Private").last.number_available - 1)
      end
    when "Searching for New ALF"
      @contact.placement = nil
      @contact.placement_status = PlacementStatus.find_by(status: "Date not set")
      
      refresh = true
    when "Deceased"
      @contact.deceased = true
      placement_type = @contact.results.where('result_type_id = ? OR result_type_id = ?', 
                          ResultType.find_by(name: "Placed Private"), 
                          ResultType.find_by(name: "Placed Semi-Private"))
                          .last.result_type.name.split[1]
      
      @contact.facility.availabilities << Availability.new(capacity_type: placement_type,
                        number_available: @contact.facility.availabilities
                            .where(capacity_type: placement_type).last.number_available + 1)
      refresh = true
    end
    @contact.results << @result
    @contact.save
    @data_file = DataFile.new
    if refresh == true
      redirect_to @contact
    else
      respond_to do |format|
        format.html
        format.js { render 'update.js.erb' }
      end
    end
  end
  
  def edit_finance
    @finance = @contact.finance
  end
  
  def save_finance
    @contact.finance.update(finance_params)
    @data_file = DataFile.new
    respond_to do |format|
      format.html
      format.js { render 'update.js.erb' }
    end
  end
  
  def decision_makers
  end
  
  def update_decision_makers
    @deciders = DecisionMaker.update(params[:decision_makers].keys, params[:decision_makers].values)
    @deciders.reject! { |p| p.errors.empty? }
    @data_file = DataFile.new
    respond_to do |format|
      format.html
      format.js { render 'update.js.erb' }
    end
  end
  
  def community_search
    @communities = Community.first(10)
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
  
  def licenses
    licenses = TaggingManual.tokens('licenses', params[:q])
    respond_to do |format|
      format.json { render json: licenses }
    end
  end
  
  def find_activity_tags
    
  end
  
  private
    def data_file_params
      params.require(:data_file).permit(:file)
    end
    
    def admin_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless current_user.admin?
    end
    
    def logged_in_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless logged_in?
    end
  
    def set_contact
      @contact = Contact.find_by_id(params[:id]) || Contact.find_by_id(params[:contact_id])
    end
    
    def contact_params
      list_params_allowed = [:first_name, :middle_name, :last_name, :salutation_male, :salutation_female, :gender,
          :email, :work_email, :home_phone, :cell_phone, :work_phone, :ssn,
          :dob_input, :address_1, :address_2, :position_id, :community_id, :company_id,
          :placement_status_id, :patient_community_id, :veteran, :pay_entry_base_date_input,
          :end_of_active_service_input, :va_application_submitted_input, :benefit_received_input,
          :placement_input, :medicaid, :medicaid_icp, :medicaid_ltmc, :deceased,
          :personal_history, :clinical_history, :contact_type, :relation, 
          :relation_id, :resident_search, :hierarchy, :zip_code_id, :activity_list_tokens,
          :dining_list_tokens, :feature_list_tokens, :undesired_list_tokens,
          :license_list_tokens, :clinic_id, :referrer_id, :medicaid_provider_id]
      
      list_params_allowed << :user_id if current_user.admin?
      params.require(:contact).permit(list_params_allowed)
    end
    
    def note_params
      params.require(:note).permit(:content)
    end
    
    def result_params
      params.require(:result).permit(:result_type_id, :community_id, :updated_at, :rate, :deferred_rate)
    end
    
    def respite_params
      params.require(:respite_stay).permit(:community_id, :start, :stop)
    end
    
    def finance_params
      params.require(:finance).permit!
    end
end