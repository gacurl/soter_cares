class CommunitySearchController < ApplicationController
  before_action :set_community, only: [:show]

  def get_contact
    @contact = Contact.new
  end

  def submit_contact
    user = User.find_by(email: 'troy@sotercares.com')
    @contact = Contact.new(
        first_name: params[:contact][:first_name],
        last_name: params[:contact][:last_name],
        contact_type: "Resident",
        user: user,
        cell_phone: params[:contact][:cell_phone],
        email: params[:contact][:email],
        web_lead: true
    )

    if @contact.save
      SendContact.perform_async(
          user.id,
          session[:medicaid_provider_ids],
          session[:medical_needs],
          session[:activity_tags],
          session[:dining_tags],
          session[:interest_ids],
          @contact.id
      )

      render 'close_modal'
    else
      flash[:danger] = 'Please check information'
      render 'get_contact'
    end
  end

  def show
  end
  
  def index
    if session[:interest_ids].present?
      session[:interest__ids] = Community.where(id: session[:interest_ids]).distinct.pluck(:id)
      session[:interest_ids] += Community.where(id: params[:community_id]).distinct.pluck(:id) if params[:community_id].present?
    elsif params[:community_id].present?
      session[:interest_ids] = Community.where(id: params[:community_id]).distinct.pluck(:id)
    else
      session[:interest_ids] = []
    end

    if params[:remove_id].present?
      session[:interest_ids].delete(params[:remove_id].to_i)
    end

    @interest_communities = Community.where(id: session[:interest_ids]).distinct
    respond_to do |format|
      format.js
      format.html {
        session[:budget] = params[:budget] if params[:budget].present?
        budget = session[:budget].to_i
        budget = 10000000 if budget == 0
        session[:budget] = budget
        if params[:distance].present?
          session[:distance] = params[:distance]
        elsif session[:distance].nil?
          session[:distance] = 10
        end

        session[:medicaid_provider_ids] = params[:medicaid_provider_ids]

        if params[:city].present?
          city_name = params[:city]
        elsif session[:city].blank?
          results = Geocoder.search(remote_ip())
          city_name = results.first.city + ', ' + results.first.region_code
        else
          city_name = session[:city]
        end

        city_search = city_name.try { strip.split(',')[0].strip.titlecase }
        state_search = city_name.try { strip.split(',')[1].try { strip.upcase } }
        city_length = city_search.length
        state_length = state_search.length if state_search

        if state_search.present?
          city = City.find_by_id(City.fetch_city_list.select{ |hash| hash["name"].first(city_length) == city_search and
              hash["state"].first(state_length) == state_search
          }.first["id"])
        else
          city = City.find_by_id(City.fetch_city_list.select{ |hash| hash["name"].first(city_length) == city_search }.first["id"])
        end

        session[:city] = city.name + ', ' + city.state

        if params[:medical_needs]
          session[:medical_needs] = params[:medical_needs]
        else
          session[:medical_needs] = nil
        end

        if session[:medical_needs].present?
          license_ids = LicenseType.tagged_with(ActsAsTaggableOn::Tag.where(id: params[:medical_needs]), on: :licenses, any: true).pluck(:id)
          if session[:medicaid_provider_ids].any?
            @communities = Community.with_licenses(license_ids).where('semi_private_cents <= ? OR private_cents <= ?', budget, budget).near(session[:city], session[:distance].to_i)
                               .joins(:medicaid_providers).where(medicaid_providers: { id: session[:medicaid_provider_ids] }).distinct
          else
            @communities = Community.with_licenses(license_ids).where('semi_private_cents <= ? OR private_cents <= ?', budget, budget).near(session[:city], session[:distance].to_i).distinct
          end

        else
          if session[:medicaid_provider_ids].any?
            @communities = Community.where('semi_private_cents <= ? OR private_cents <= ?', budget, budget).near(session[:city],  session[:distance].to_i)
                               .joins(:medicaid_providers).where(medicaid_providers: { id: session[:medicaid_provider_ids] }).distinct
          else
            @communities = Community.where('semi_private_cents <= ? OR private_cents <= ?', budget, budget).near(session[:city],  session[:distance].to_i).distinct
          end
        end

        session[:activities] =  params[:activities] if params[:activities]
        session[:dining] =  params[:dining] if params[:dining]
        session[:activity_tags] = [] if session[:activity_tags].nil?
        session[:dining_tags] = [] if session[:dining_tags].nil?
        session[:activity_tags] = ActsAsTaggableOn::Tag.where(id: params[:activities]).pluck(:name) if params[:activities]
        session[:dining_tags] = ActsAsTaggableOn::Tag.where(id: params[:dining]).pluck(:name) if params[:dining]
        if session[:activity_tags].present? && session[:dining_tags].blank?
          tags = session[:activity_tags]
          @communities = @communities.sort_by { |o| -(tags & (o.dining_list + o.activity_list + o.feature_list + o.undesired_list)).length }.paginate(page: params[:page], :per_page => 5)
        elsif session[:activity_tags].blank? && session[:dining_tags].present?
          tags = session[:dining_tags]
          @communities = @communities.sort_by { |o| -(tags & (o.dining_list + o.activity_list + o.feature_list + o.undesired_list)).length }.paginate(page: params[:page], :per_page => 5)
        elsif session[:activity_tags].present? && session[:dining_tags].present?
          tags = session[:activity_tags] + session[:dining_tags]
          @communities = @communities.sort_by { |o| -(tags & (o.dining_list + o.activity_list + o.feature_list + o.undesired_list)).length }.paginate(page: params[:page], :per_page => 5)
        else
          @communities = @communities.paginate(page: params[:page], :per_page => 5)
        end
      }
    end

  rescue
    @communities = Community.where(name: nil).paginate(page: params[:page], :per_page => 5)
    flash.now[:danger] = 'Please enter a valid value'
    render 'index'
  end
  
  private
    def send_email
      user = User.find_by(email: 'troy@sotercares.com')
      message = "WEBSITE LEAD\n"
      message += "MEDICAID PROVIDERS:\n"
      MedicaidProvider.where(id: session[:medicaid_provider_ids]).each do |mp|
        message += mp.name + "\n"
      end
      message += "\nMedical Needs:\n"
      message += ActsAsTaggableOn::Tag.where(id: session[:medical_needs]).pluck(:name).join(', ')
      message += "\nActivities:\n"
      message += session[:activity_tags].join(',') + "\n"
      message += "\nDining:\n"
      message += session[:dining_tags].join(', ') + "\n"

      message += "\nINTERESTED COMMUNITIES\n"
      interest_communities = Community.where(id: session[:interest_ids]).distinct
      @contact.prospects << interest_communities
      interest_communities.each do |community|
        message += community.name + '-' + community.id.to_s + "\n"
      end

      @contact.results << Result.new(result_type: ResultType.find_by(name: "Qualified, OK to pursue"))

      user.send_notification_email(message)
    end

    def set_community
      @community = Community.find_by_id(params[:id]) || Community.find_by_id(params[:community_id])
    end
end