class Profile 
	include ActiveModel::Model
	attr_accessor :profilable_type, :profilable_id, :global_id, :display
	PROFILE_TYPES = ["Twitter", "Facebook"] #Model Class Name
	PROFILE_REGEXP = {"Twitter" => "twitter.com", "Facebook" => "facebook.com"} #Regexp to improve
	PROFILE_NAME_PLURAL = {"Twitter" => "twitters", "Facebook" => "facebooks"} #has_many...plural naming
	PROFILE_NAME_SINGULAR = {"Twitter" => "twitter", "Facebook" => "facebook"} #belongs_to...singular naming
	PROFILE_ACTIVATION_TO_DESTROY = {"Twitter" => false, "Facebook" => true} #has an activation process named ClassName+"Activation" or not ?
	
	def self.is_it?(type, display) # ==>match_regexp ?
		return display.include?(PROFILE_REGEXP[type])
	end
	
	def self.build_with(type, display)
		description = display.split(PROFILE_REGEXP[type])[1].split('/')[1]
		profile = type.constantize.find_or_initialize_by(description: description)
		return profile
	end 
end

