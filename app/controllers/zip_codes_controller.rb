class ZipCodesController < ApplicationController
  def autocomplete
    @zips = ZipCode.search(params[:term])
    @zip_hash = []
    @zips.each do |zip|
      label = zip.code
      label << " - #{zip.city.name}, #{zip.city.county.state.two_digit_code}"
        
      @zip_hash << { 
          label: label,
          value: zip.id 
      }
    end
    
    render json: @zip_hash
  end
  
end