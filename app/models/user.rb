
class User < ActiveRecord::Base
	# DEVISE
	devise 	:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
	validates :name, presence: true
	validates_uniqueness_of :name, :case_sensitive => false, :message => "This name has already been taken"
	
	# PROFILE Management	
	Profile::PROFILE_TYPES.each do |x|
		eval("has_many :"+Profile::PROFILE_NAME_PLURAL[x]+", as: :owner, class_name: "+x)
	end
	
	def profiles 
		code_string = Profile::PROFILE_TYPES.collect{|x| "self."+Profile::PROFILE_NAME_PLURAL[x]}
		code_string = code_string.join(" + ")
		return eval(code_string)
	end
			
	def can_post?(conversation)
		return true
	end
	
	def can_call?(conversation)
		return conversation.persisted?
	end
		
	#if call has given a post or child calls, the s/u have been switched to the post. the call can't be s/u anymore
	def can_s_call?(call)
		return call.callable != self && !call.supporters.include?(self) && call.status == "active" && !call.declined && call.post.nil?
	end
	def can_u_call?(call)
		return call.callable != self && !call.unsupporters.include?(self) && call.status == "active" && !call.declined && call.post.nil?
	end
	def can_remove_s_or_u_call?(call)
		return call.callable != self && (call.supporters.include?(self) || call.unsupporters.include?(self)) && !call.declined && call.post.nil? && call.status == "active"
	end
	
	def can_answer_call?(call)
		return call.callable == self && call.post.nil? && call.status == "active" && !call.declined
	end	
	
	def can_edit_post?(post)
		return post.creator == self  
	end
	
	def can_s_post?(post)
		return !post.supporters.include?(self) && post.status == "active"
	end
	def can_u_post?(post)
		return post.creator != self && !post.unsupporters.include?(self) && post.status == "active"
	end
	def can_remove_s_or_u_post?(post)
		return (post.supporters.include?(self) || post.unsupporters.include?(self)) && post.status == "active"
	end
	
	def supports(object)
		oa = ObjectAction.find_or_initialize_by(creator: self, object: object)
		oa.support = "up"
		oa.status = "active"
		oa.save!
	end
	
	def unsupports(object)
		oa = ObjectAction.find_or_initialize_by(creator: self, object: object)
		oa.support = "down"
		oa.status = "active"
		oa.save!
	end
	
	def remove(object)
		oa = ObjectAction.find_by(creator: self, object: object)
		oa.status = "removed"
		oa.save!
	end


	
	# CALL Management
	#CALL S/U
	has_many :object_actions, inverse_of: :creator
	#has_many :callouts, through: :object_actions, source: :object, source_type: 'Call', foreign_key: "object_id"

	def callouts
		return Call.select{|x| x.supporters.include?(self) || x.unsupporters.include?(self)}
	end
	has_many :callins, as: :callable, class_name: "Call"

	# POST Management + POST S/U
	has_many :posts, inverse_of: :creator, foreign_key: "creator_id"
	has_many :postsupports, through: :object_actions, source: :object, source_type: "Post"

	
	# FB Activations	
	# MAKE MORE GENERAL
	has_many :facebook_activations
	
	# Functions
	def has_this_profile?(profile)
		profiles.include?(profile)
	end
	def has_this_facebook_activation?(facebook_activation)
		id == facebook_activation.creator.id
	end
	def has_pending_facebook_activations?(facebook)
		facebook.facebook_activations.collect{|fba| fba.creator}.include?(self)
	end
	def has_been_reported_for_facebook?(facebook)
		facebook.facebook_activations.select{|fba| fba.creator == self && fba.reported}.any?
	end
	def has_recent_facebook_activations?(facebook)
		facebook.facebook_activations.where("upadated_at > ?", 2.minutes.ago).collect{|fba| fba.creator}.include?(self)
	end
	def is_user?
		true
	end
	def is_potential_user?
		false
	end
	
	#DEVISE Soft Delete
	# instead of deleting, indicate the user requested a delete & timestamp it  
	def soft_delete  
		update_attribute(:deleted_at, Time.current)  
	end  

	# ensure user account is active  
	def active_for_authentication?  
		super && !deleted_at  
	end  

	# provide a custom message for a deleted account   
	def inactive_message   
		!deleted_at ? super : :deleted_account  
	end 
end	
