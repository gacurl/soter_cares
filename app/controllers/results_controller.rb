class ResultTypesController < ApplicationController
  before_action :logged_in_user

  def new
  end
  
  def create
    
  end
  
  private
    def logged_in_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless logged_in?
    end
  
    def set_contact
      @contact = Contact.find_by_id(params[:id]) || Contact.find_by_id(params[:contact_id])
    end
    
end