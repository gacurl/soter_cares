class DataFilesController < ApplicationController
  before_action :set_object
  
  def create
    @data_file = @object.data_files.new(data_file_params)
    @data_file.user = current_user
    respond_to do |format|
      if @data_file.save
        format.html { redirect_to @object, flash: { success: 'File was successfully uploaded.' } }
        format.json { render :show, status: :created, location: [@object, @data_file] }
      else
        format.html { render :new }
        format.json { render json: @data_file.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    def set_object
      if params[:contact_id]
        @object = Contact.find_by_id(params[:contact_id])
      elsif params[:community_id]
        @object = Community.find_by_id(params[:community_id])
      elsif params[:company_id]
        @object = Company.find_by_id(params[:company_id])
      end
    end
    
    def data_file_params
      params.require(:data_file).permit(:file)
    end
end