class ApplicationController < ActionController::Base
	include GlobalIdModule

	protect_from_forgery with: :exception
	
	def after_sign_in_path_for(resource)
		sign_in_url = new_user_session_url
		if request.referer == sign_in_url
			super
		else
			stored_location_for(resource) || request.referer || root_path
		end
	end
	
	#devise setup
	before_action :configure_permitted_parameters, if: :devise_controller?
	protected
	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) << :name
		devise_parameter_sanitizer.for(:account_update) << :name
	end
end
