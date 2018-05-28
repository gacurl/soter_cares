class ValidationsController < ApplicationController
  def edit
    contact = Contact.find_by(email: params[:email])
    if contact && !contact.validated?
      contact.update(validated: true)
      flash[:success] = "Thank you for validating your E-mail."
      redirect_to location_search_journies_path(lead_id: contact.id, prospect_id: params[:prospect_id])
    elsif contact && contact.validated?
      flash[:info] = "Welcome back!"
      redirect_to location_search_journies_path(lead_id: contact.id, prospect_id: params[:prospect_id])
    else
      flash[:danger] = "Invalid link"
      redirect_to root_url
    end
  end
end

