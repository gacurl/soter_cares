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

  def autocomplete_name
    city_search = params[:term].strip.split(',')[0].strip.titlecase
    state_search = params[:term].strip.split(',')[1].try(:strip).try(:upcase)
    city_length = city_search.length
    state_length = state_search.length if state_search

    if state_search.present?
      cities = City.fetch_city_list.select{ |hash| hash["name"].first(city_length) == city_search and
          hash["state"].first(state_length) == state_search
      }
    else
      cities = City.fetch_city_list.select{ |hash| hash["name"].first(city_length) == city_search }
    end

    city_list = []

    cities.each do |city|
      label = "#{city["name"]}, #{city["state"]}"
      city_list << {
          label: label,
          value:  city["id"]
      }
    end

    render json: city_list
  end
  
end

  class String
    def is_number?
      true if Float(self) rescue false
    end
  end