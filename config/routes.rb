Decide::Application.routes.draw do

  match 'twilio/event' => 'twilio#event', :method => 'post'
  
  match 'decisions/:decision_id/discussion.json' => 'discussion#show', :method => 'get'
  match 'decisions/:decision_id/choices/new' => 'choice#new', :method => 'post'
  post "choice/create"
  post "choice/update"
  post "choice/destroy"

  match 'choices/:choice_id/vote.json' => 'vote#create', :method => 'get'
  match 'choices/:choice_id/delete_vote.json' => 'vote#destroy', :method => 'get'

  match 'discussion/add_reply/:id' => 'discussion#add_reply', :method => 'post'
  match 'discussion/new_comment/:id' => 'discussion#new_comment', :method => 'post'

  match "about" => "home#about"
  match "contact"  => "home#contact"

  resources :decisions

  root :to => 'home#index'

  #devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

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
