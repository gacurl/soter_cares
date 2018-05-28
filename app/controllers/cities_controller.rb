class CitiesController < ApplicationController
  def autocomplete
    @cities = City.search(params[:term])
    @city_hash = []
    @cities.each do |city|
      label = "#{city.name}, #{city.county.state.two_digit_code}"
        
      @city_hash << { 
          label: label,
          value: city.id 
      }
    end
    
    render json: @city_hash
  end
  
end