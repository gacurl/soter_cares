class NotesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :set_note, only: [:destroy]
  
  def new
    @note = Note.new
  end
  
  def destroy
    if @note.destroy
      flash[:success] = "Note deleted."
      redirect_to current_user
    end
  end
  
  private
    def set_note
      @note = Note.find_by_id(params[:id])
    end
    
    def logged_in_user
      redirect_to root_url, flash: { danger: "Authorization failure" } unless logged_in?
    end
    
    def admin_user
      redirect_to current_user, flash: { danger: "Authorization failure" } unless current_user.admin?
    end
  
end