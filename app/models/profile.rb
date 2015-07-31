class Profile < ActiveRecord::Base

	belongs_to :profileable, polymorphic: true, class_name: "::Profile"
	#validates_inclusion_of :profileable_type, in: ["User","PotentialUser"]
		
	belongs_to :identable, polymorphic: true, class_name: "::Profile"
	#validates_inclusion_of :profileable_type, in: ["User","PotentialUser"]
	
	validates_uniqueness_of :profileable_id, :scope => [:identable_id, :identable_type,:profileable_type,],	:message => "Error on the join model. This association profileable/identable already exists"
	
	#attach the self profile to user. If profile was owned by a PotentialUser, the PotentialUser is destroyed
	def add_profile_to(user)
		user_destroy =  self.profileable
		user.profiles << self
		user_destroy.destroy! if user_destroy.class.name == "PotentialUser"
	end
end

