Rails.application.routes.draw do
  get 'sessions/new'

  root    'static_pages#home'
#  mount Sidekiq::Web, at: '/sidekiq'
#  mount Resque::Server, :at => "/resque"
  mount FileUploader::UploadEndpoint => "/data_files/upload"
  mount ImageUploader::UploadEndpoint => "/photos/upload"
  
  require 'sidekiq/web'
  require 'admin_constraint'
  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new
  
  get     'settings'         => 'static_pages#settings'
  get     'team'         => 'static_pages#team'
  get     'testimonials'         => 'static_pages#testimonials'
  get     'terms'         => 'static_pages#terms'
  get     'privacy'         => 'static_pages#privacy'
  get     'login'             => 'sessions#new'
  post    'login'             => 'sessions#create'
  delete  'logout'            => 'sessions#destroy'
  
  resources :journies do
    collection do 
      get :start
      get :living
      post :update_living
      get :medical
      post :update_medical
      get :budget
      post :update_budget
      get :veteran
      patch :update_veteran
      get :activities
      post :update_activities
      get :prospect_priorities
      post :update_prospect_priorities
      get :lead_priorities
      post :update_lead_priorities
      get :prospect_name
      patch :update_prospect_name
      get :lead_name
      get :update_lead_name
      patch :update_lead_name
      get :age
      post :update_age
      get :phone
      patch :update_phone
      get :validate_code
      post :check_code
      get :email
      patch :update_email
      get :rep
      get :location_search
      get :distance_search
      post :update_prospective_communities
    end
  end
  
  resources :users do
    get :password
    post :resend_activation_email
    patch :update_password
    
    collection do
      put :update_multiple
    end
  end
  
  resources :companies do
    resources :data_files
    get :new_note
    post :save_note
    collection do
      get :autocomplete
    end 
  end
  
  resources :pharmacies do
    get :new_note
    post :save_note
    collection do
    end
  end
  
  resources :contacts do
    resources :data_files
    get :distance_search
    get :community_search
    get :new_note
    get :new_result
    get :new_respite
    get :edit_result
    get :edit_finance
    get :decision_makers
    post :update_prospective_communities
    post :destroy_prospective_communities
    post :save_note
    post :save_result
    patch :save_result
    post :save_respite
    patch :save_finance
    patch :add_family
    put :update_decision_makers
    collection do
      get :autocomplete_resident
      get :autocomplete_family
      get :autocomplete_business
      get :autocomplete_clinician
      get :autocomplete
      get :activities, as: :activities
      get :dinings, as: :dinings
      get :features, as: :features
      get :undesireds, as: :undesireds
      get :licenses, as: :licenses
    end 
  end

  resources :community_search, only: [:index, :show] do
    collection do
      post :index
      get :add_to_interest
      get :get_contact
      post :submit_contact
    end
  end

  resources :communities do
    resources :data_files
    resources :photos
    get :new_note
    post :save_note
    get :autocomplete_pharmacies
    collection do
      get :autocomplete
      get :activities, as: :activities
      get :dinings, as: :dinings
      get :features, as: :features
      get :undesireds, as: :undesireds
      get :licenses, as: :licenses
    end 
  end
  
  resources :activities do
    collection do
      put :update_multiple
    end
  end
  resources :dinings do
    collection do
      put :update_multiple
    end
  end
  resources :positions do
    collection do
      put :update_multiple
    end
  end
  resources :features do
    collection do
      put :update_multiple
    end
  end
  resources :license_types do
    collection do
      put :update_multiple
    end
  end
  resources :result_types do
    collection do
      put :update_multiple
    end
  end
  resources :placement_statuses do
    collection do
      put :update_multiple
    end
  end
  resources :medicaid_providers do
    collection do
      put :update_multiple
    end
  end
  resources :zip_codes do
    collection do
      get :autocomplete
    end 
  end
  
  resources :cities do
    collection do
      get :autocomplete
      get :autocomplete_name
    end
  end
  
  resources :users,               except: [:destroy]
  resources :account_activations, only: [:edit]
  resources :validations, only: [:edit]
  resources :notes,               only: [:destroy]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :photos, only: [:update]
end
