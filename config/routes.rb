Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords"}
  #devise_for :users, :controllers => { :registrations => 'registrations' }
  
  resources :users, only: [ :show] 
  resources :potential_users, only: [ :show]
  
  root 'static_pages#home'
  resources :conversations, only: [:new, :show] 
  
  resources :conversations do #ici ça génère trop de lignes
		resources :posts, only: [:create, :edit]
		resources :calls, only: [:create]
		resources :aftfs, only: [:create]
  end	
  
  resources :posts, only: [:create, :destroy, :update]
  post 'posts/:id/support' => 'posts#support'
  delete 'posts/:id/remove' => 'posts#remove'
  post 'posts/:id/unsupport' => 'posts#unsupport' 
  
  post 'calls/:id/support' => 'calls#support'
  delete 'calls/:id/remove' => 'calls#remove'
  post 'calls/:id/unsupport' => 'calls#unsupport'
  
  resources :calls, only: [:create]

  resources :aftfs, only: [:create, :destroy]
  post 'aftfs/:id/support' => 'aftfs#support'
  delete 'aftfs/:id/remove' => 'aftfs#remove'
  post 'aftfs/:id/unsupport' => 'aftfs#unsupport'
  post 'aftfs/:id/accept' => 'aftfs#accept'
  post 'aftfs/:id/refuse' => 'aftfs#refuse'
  
  post 'profiles/attach_to_user' => 'profiles#attach_to_user' 
  post 'profiles/detach_from_user' => 'profiles#detach_from_user'
  
  resources :facebooks do #ici ça génère trop de lignes
		resources :facebook_activations, only: [:new, :create]
		get "/facebook_activations/:id/report_page" => 'facebook_activations#report_page' 
		post "/facebook_activations/:id/report_as_abusive" => 'facebook_activations#report_as_abusive'
  end
  
  get "/facebooks/:facebook_id/facebook_activations/validate" => 'facebook_activations#validate' 
  
  post "/facebook_activations/:id/resend" => 'facebook_activations#resend' 
  delete "/facebook_activations/:id/cancel" => 'facebook_activations#cancel' 
  
  post "/users/:id/support" => 'users#support'
  post "/potential_users/:id/support" => 'potential_users#support'
  post "/users/:id/unsupport" => 'users#unsupport'
  post "/potential_users/:id/unsupport" => 'potential_users#unsupport'
  delete "/users/:id/remove_support" => 'users#remove_support'
  delete "/potential_users/:id/remove_support" => 'potential_users#remove_support'
  
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
