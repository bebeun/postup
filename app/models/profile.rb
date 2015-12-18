class Profile 
	include ActiveModel::Model
	attr_accessor :profilable_type, :profilable_id, :global_id, :display
	PROFILE_TYPES = ["Twitter", "Facebook", "Website"] #Model Class Name
	PROFILE_REGEXP = {"Twitter" => ".*twitter.com\/(?<description>[^\/]{2,})", "Facebook" => ".*facebook.com\/(?<description>[^\/]{2,})", "Website" => "(?<description>[a-z0-9[^\.]]{2,}(?:.com|.org|.net|.fr)\s*)"} 
	PROFILE_NAME_PLURAL = {"Twitter" => "twitters", "Facebook" => "facebooks", "Website" => "websites"} #has_many...plural naming
	PROFILE_NAME_SINGULAR = {"Twitter" => "twitter", "Facebook" => "facebook", "Website" => "website"} #belongs_to...singular naming
	PROFILE_ACTIVATION_TO_DESTROY = {"Twitter" => false, "Facebook" => true, "Website" => false} #has an activation process named ClassName+"Activation" or not ?
	PROFILE_SYMBOL = {"Twitter" => "TW", "Facebook" => "FB", "Website" => "WEB"} 
end
