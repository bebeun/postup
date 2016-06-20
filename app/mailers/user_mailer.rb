class UserMailer < ApplicationMailer
	def facebook_activation(facebook_activation, current_user)
		@name = current_user.name
		@email = current_user.email
		@url_defined =  root_url+"facebooks/"+facebook_activation.facebook.id.to_s+"/facebook_activations/validate?token="+facebook_activation.token+"&uid="+current_user.id.to_s
		@url_report =  root_url+"facebooks/"+facebook_activation.facebook.id.to_s+"/facebook_activations/"+facebook_activation.id.to_s+"/report_page?token="+facebook_activation.token
		mail from: current_user.email, to: facebook_activation.facebook.description+"@facebook.com", subject: "Your Facebook account association on PostUp."
	end
end
