Rails.application.routes.draw do
	devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords"}
  
	resources :users, only: [ :show] 
	resources :potential_users, only: [ :show]
  
	root 'static_pages#home'
	resources :conversations, only: [:create, :show] 
  
	resources :conversations do #ici ça génère trop de lignes
		resources :posts, only: [:create]
		resources :calls, only: [:create]
	end	
  
	resources :posts, only: [:update, :edit]
	
	post 'posts/:id/support' => 'posts#support'
	delete 'posts/:id/remove' => 'posts#remove'
	post 'posts/:id/unsupport' => 'posts#unsupport' 
	#post 'posts/:id/hide' => 'posts#hide'
  
	post 'calls/:id/support' => 'calls#support'
	delete 'calls/:id/remove' => 'calls#remove'
	post 'calls/:id/unsupport' => 'calls#unsupport'
	post 'calls/:id/decline' => 'calls#decline'
  
  
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
  
  	resources :twitters do #ici ça génère trop de lignes
		resources :twitter_activations, only: [:new]
	end
	get "/twitters/:twitter_id/twitter_activations/validate" => 'twitter_activations#validate' 
	get "/twitters/:twitter_id/twitter_activations/fail" => 'twitter_activations#fail'
	
	resources :websites do #ici ça génère trop de lignes
		resources :website_activations, only: [:new]
	end
	get "/websites/:website_id/website_activations/validate" => 'website_activations#validate' 
	get "/websites/:website_id/website_activations/fail" => 'website_activations#fail'

end
