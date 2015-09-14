class Profile 
	include ActiveModel::Model
	attr_accessor :profilable_type, :profilable_id, :global_id, :display
	PROFILE_TYPES = ["Twitter", "Facebook"]
	PROFILE_REGEXP = {"Twitter" => "twitter.com", "Facebook" => "facebook.com"}
	
	def self.is_it?(type, display)
		return display.include?(PROFILE_REGEXP[type])
	end
	
	def self.build_with(type, display)
		description = display.split(PROFILE_REGEXP[type])[1].split('/')[1]
		profile = type.constantize.find_or_initialize_by(description: description)
		return profile
	end 
end

