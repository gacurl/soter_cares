class JourniesController < ApplicationController
  before_action :set_contacts, except: [:start, :living]
  before_action :validated_user, only: [:location_search]
  
  def update_prospective_communities
    @community = Community.find_by_id(params[:community_id])
    @prospect.prospects << @community
    @prospect.notes << Note.new(content: "Community #{@community.name}(ID: #{@community.id}) sent claim email")
    @community.send_claim_email(@prospect.id, @lead.id)
  end 
  
  def distance_search
    city = City.find_by_id(params[:city_id])
    if @prospect.license_list.present?
      license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
      @communities = Community.with_licenses(license_ids).near("#{city.name}, #{city.county.state.two_digit_code}", params[:distance].to_i)
    else
      @communities = Community.near("#{city.name}, #{city.county.state.two_digit_code}", params[:distance].to_i)
    end
    tags = @prospect.dining_list + @prospect.activity_list + @prospect.feature_list + @prospect.undesired_list
    @communities = @communities.sort_by { |o| -(tags & (o.dining_list + o.activity_list + o.feature_list + o.undesired_list)).length }                  
  #  @activities = Community.tag_counts_on(:activities)
  end
  
  def start
  end
  
  def living
    @prospect = Contact.new(contact_type: "Resident", first_name: "Unknown", last_name: "Unknown")
    unless params[:self_guided] && params[:self_guided] == true
      @lead = Contact.create(contact_type: "Family", first_name: "Unknown", last_name: "Unknown")
      @prospect.relationships << Relationship.new(relationship_type: RelationshipType.find_by_id(params[:relationship_type_id]), relation: @lead)
      @prospect.gender = params[:gender] if params[:gender] == "Male" || params[:gender] == "Female"
      @prospect.save
    else
      @lead = @prospect
    end
  end
  
  def update_living
    @prospect.notes << Note.new(content: params[:home_alone]) if params[:home_alone]
    @prospect.notes << Note.new(content: params[:home_with_spouse]) if params[:home_with_spouse]
    @prospect.notes << Note.new(content: params[:friend]) if params[:friend]
    @prospect.notes << Note.new(content: params[:family]) if params[:family]
    @prospect.notes << Note.new(content: params[:rehab]) if params[:rehab]
    @prospect.notes << Note.new(content: params[:hospital]) if params[:hospital]
    @prospect.notes << Note.new(content: params[:state]) if params[:state]
    redirect_to medical_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
  end
  
  def medical
    
  end
  
  def update_medical
    @prospect.assign_attributes(new_license_list_tokens: params[:new_license_list_tokens])
    @prospect.save
    redirect_to budget_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
  end
  
  def budget
    @finance = Finance.new
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def update_budget
    @prospect.finance = Finance.create(finance_params)
    redirect_to veteran_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
  end
  
  def veteran
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def update_veteran
    @prospect.update(contact_params)
    redirect_to activities_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
  end
  
  def activities
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def update_activities
    @prospect.assign_attributes(new_activity_list_tokens: params[:new_activity_list_tokens])
    @prospect.save
    redirect_to prospect_priorities_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
  end
  
  def prospect_priorities
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def lead_priorities
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def update_prospect_priorities
    @prospect.notes << Note.new(content: params[:priority] + " most important to Prospect.")
    if @lead == @prospect
      redirect_to prospect_name_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
    else
      redirect_to lead_priorities_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
    end
  end
  
  def update_lead_priorities
    @prospect.notes << Note.new(content: params[:priority] + " most important to Family.")
    redirect_to lead_name_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
  end
  
  def prospect_name
    @prospect.first_name = nil
    @prospect.last_name = nil
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def lead_name
    @lead.first_name = nil
    @lead.last_name = nil
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def update_lead_name
    if @lead.update(contact_params)
      redirect_to prospect_name_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
    else
      license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
      @communities = Community.with_licenses(license_ids)
      render :lead_name
    end
  end
  
  def update_prospect_name
    if @prospect.update(contact_params)
      redirect_to age_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
    else
      license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
       @communities = Community.with_licenses(license_ids)
      render :prospect_name
    end
  end
  
  def age
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def update_age
    @prospect.notes << Note.new(content: "Prospect age: " + params[:age])
    redirect_to phone_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
  end
  
  def phone
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def update_phone
    if @lead.update(contact_params)
      if @lead.cell_phone.present?
        @lead.send_code
        redirect_to validate_code_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
      else
        redirect_to email_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
      end
    else
      license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
      @communities = Community.with_licenses(license_ids)
      render :phone
    end
  end
  
  def validate_code
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def check_code
    if params[:code] == @lead.phone_code
      @lead.update(validated: true)
      flash[:success] = "Cell phone validated"
      redirect_to email_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
    else
      flash[:danger] = "Invalid code"
      redirect_to phone_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
    end
  end
  
  def email
    license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
    @communities = Community.with_licenses(license_ids)
  end
  
  def update_email
    if @lead.update(contact_params)
      if @lead.email.present?
        @lead.send_validation_email(@prospect.id)
        redirect_to rep_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
      elsif @lead.validated?
        redirect_to rep_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
      else
        flash[:danger] = "Either a valid cell phone or email must be provided"
        redirect_to phone_journies_path(prospect_id: @prospect.id, lead_id: @lead.id)
      end
    else
      license_ids = LicenseType.tagged_with(@prospect.license_list, on: :licenses, any: true).pluck(:id)
      @communities = Community.with_licenses(license_ids)
      render :email
    end
  end
  
  def rep
    UserMailer.initial_lead("info@sotercares.com", @prospect.id, @lead.id).deliver_now
    @prospect.results << Result.new(result_type: ResultType.find_by(name: "Qualified, OK to pursue"))
  end
  
  def location_search
    @communities = []
  end
  
  private
    def validated_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless @lead.validated?
    end
  
    def finance_params
      params.require(:finance).permit!
    end
    
    def set_contacts
      @prospect = Contact.find_by_id(params[:prospect_id])
      @lead = Contact.find_by_id(params[:lead_id])
    end
    
    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :cell_phone, :home_phone, :work_phone, :email,
        :license_list_tokens, :veteran, :activity_list_tokens)
    end
end