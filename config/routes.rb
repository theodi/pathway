Rails.application.routes.draw do

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :user, :controller => "user"
  
  get 'organisations' => 'organisations#index', as: 'organisations'
  get 'assessments/begin' => 'assessments#begin', as: 'begin_assessment'
  
  get 'assessments/:id/report' => 'assessments#report', as: 'report'
  post 'assessments/:id/report' => 'assessments#complete', as: 'complete_assessment'
  
  get 'assessments/:assessment_id/targets' => 'targets#edit', as: 'edit_assessment_targets'
  patch 'assessments/:assessment_id/targets' => 'targets#update', as: 'assessment_targets'

  resources :assessments do
    get 'questions/:question_id' => 'assessment_answers#new', as: 'question'
    post 'questions/:question_id' => 'assessment_answers#create', as: 'question_answer'
    get 'assessment_answers/:id' => 'assessment_answers#edit', as: 'edit_answer'
    patch 'assessment_answers/:id' => 'assessment_answers#update', as: 'answer'
  end

  get 'assessments/:assessment_id/continue' => 'assessment_answers#continue', as: 'continue_assessment'

  get 'organisation_admins/:organisation_id/contact' => 'organisation_admins#new_contact', as: 'contact_organisation_admin'
  post 'organisation_admins/:organisation_id/contact' => 'organisation_admins#contact'

  get '/terms-of-use' => 'high_voltage/pages#show', id: 'terms_of_use'
  get '/privacy-policy' => 'high_voltage/pages#show', id: 'privacy_policy'
  get '/cookie-policy' => 'high_voltage/pages#show', id: 'cookie_policy'
  get '/about' => 'high_voltage/pages#show', id: 'about'
    
  get '/statistics' => 'statistics#index'
  get '/statistics/data' => 'statistics#data'
  get '/statistics/all_organisations' => 'statistics#all_organisations', defaults: {format: :json}
  get '/statistics/all_dgu_organisations' => 'statistics#all_dgu_organisations', defaults: {format: :json}
  get '/statistics/summary' => 'statistics#summary', defaults: {format: :json}  

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
  
  root to: "home#index"
  
  get "admin" => "admin#index"
end
