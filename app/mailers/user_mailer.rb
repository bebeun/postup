class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.facebook_activation.subject
  #
  def facebook_activation(facebook_activation, current_user)
	@name = current_user.name
	@email = current_user.email
    @url_defined =  root_url+"facebooks/"+facebook_activation.facebook.id.to_s+"/facebook_activations/validate?token="+facebook_activation.token+"&uid="+current_user.id.to_s
	
    mail to: facebook_activation.facebook.description+"@facebook.com"
  end
end
