Rails.application.routes.draw do

  post "set_status/appointments/:id/:status_name", to: 'appointment_status#set_status', as: :appointment_set_status
  post "set_status/appointments/:id/:status_name/companies/:company_parent_id", to: 'appointment_status#set_status', as: :appointment_set_status_from_company
  post "set_status/appointments/:id/:status_name/people/:person_parent_id", to: 'appointment_status#set_status', as: :appointment_set_status_from_person
  post "set_status/appointments/:id/:status_name/opportunities/:opportunity_parent_id", to: 'appointment_status#set_status', as: :appointment_set_status_from_opportunity

  post "set_status/opportunities/:id/:status_name", to: 'opportunity_status#set_status', as: :opportunity_set_status
  post "set_status/opportunities/:id/:status_name/companies/:company_parent_id", to: 'opportunity_status#set_status', as: :opportunity_set_status_from_company
  post "set_status/opportunities/:id/:status_name/people/:person_parent_id", to: 'opportunity_status#set_status', as: :opportunity_set_status_from_person

  resources :opportunities do
    member do
      post "next_stage", to: 'opportunities#next_stage', as: :next_stage
      post "prev_stage", to: 'opportunities#prev_stage', as: :prev_stage
    end
    collection do
      get "funnel_data", to: 'opportunities#funnel_data', as: :funnel_data
    end
  end

  get 'workspaces/index'

  devise_for :users, :controllers => {:registrations => "users/registrations", :sessions => "users/sessions"}
  resources :users do
    member do
      post 'activate' => 'users#activate', as: :activate
      post 'stop' => 'users#stop', as: :stop
    end
  end

  resources :people do
    member do
      post 'activate' => 'people#activate', as: :activate
      post 'stop' => 'people#stop', as: :stop
    end
    collection do
      get "live_search", to: 'people#live_search', as: :live_search
    end
  end

  resources :companies do
    member do
      post 'activate' => 'companies#activate', as: :activate
      post 'stop' => 'companies#stop', as: :stop
    end
    collection do
      get "live_search", to: 'companies#live_search', as: :live_search
    end
  end

  get 'appointments/:id/edit/companies/:company_parent_id', to: 'appointments#edit', as: :edit_appointments_from_company
  get 'appointments/new/companies/:company_parent_id', to: 'appointments#new', as: :new_appointments_from_company

  get 'appointments/:id/edit/people/:person_parent_id', to: 'appointments#edit', as: :edit_appointments_from_person  
  get 'appointments/new/people/:person_parent_id', to: 'appointments#new', as: :new_appointments_from_person

  get 'appointments/:id/edit/opportunities/:opportunity_parent_id', to: 'appointments#edit', as: :edit_appointments_from_opportunity
  get 'appointments/new/opportunities/:opportunity_parent_id', to: 'appointments#new', as: :new_appointments_from_opportunity

  resources :appointments, except: [:index, :destroy]

  get 'company_tags/:tag', to: 'companies#index', as: :company_tag
  get 'person_tags/:tag', to: 'people#index', as: :person_tag

  get 'removed_companies', to: 'companies#index', :defaults => {:removed => "true"}, as: :removed_companies
  get 'removed_people', to: 'people#index', :defaults => {:removed => "true"}, as: :removed_people  

  root 'workspaces#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
