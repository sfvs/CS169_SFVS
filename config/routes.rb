SFVSRegistrationSystem::Application.routes.draw do

  # namespace for the group of controllers for admin
  namespace :admin do
    root to: "admin#index"
    post "update_app_year", to: "admin#update_app_year"

    resources :users do
      post "search", on: :collection
      post "filter", on: :collection
      resources :applications, :only => [:show, :edit, :update] do
        get "form", to: "application_form#show", on: :member
        get "edit_form", to: "application_form#edit", on: :member
        put "edit_form", to: "application_form#update", on: :member
        post "approve", to: "applications#approve", on: :member
      end
    end
    resources :forms, :only => :index do
      resources :form_questions do
        put :sort, on: :collection
      end
    end
  end

  root :to => 'home#index'

  # These two routes are for payment processing
  # verify_payment is post request from paypal
  # payment_receipt is thankyou notice to the user
  # and redirects back to root  
  post "/verify_payment", :to => "payment#verify_payment"
  post "/payment_receipt", :to => "payment#thankyou"

  # name to prevent resource: user and devise routes from overlapping
  devise_for :users, :path => 'member'
  resources :users do 
    resources :form_question, :path => 'form', only: [:show, :update], on: :member
    
    get "survey", to: "survey#questionnaire", on: :member
    post "submit_survey", to: "survey#submit_questionnaire", on: :member

    get "download_file", to: "file_attachment#download_file", on: :member
    post "upload_file", to: "file_attachment#upload_file", on: :member

    post "submit_application", on: :member
    
    post "submit_payment", on: :member
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
