class Profile < ActiveRecord::Base

	belongs_to :profileable, polymorphic: true, class_name: "::Profile"
	#validates_inclusion_of :profileable_type, in: ["User","PotentialUser"]
		
	belongs_to :identable, polymorphic: true, class_name: "::Profile"
	#validates_inclusion_of :profileable_type, in: ["User","PotentialUser"]
	
	validates_uniqueness_of :profileable_id, :scope => [:identable_id, :identable_type,:profileable_type,],	:message => "Error on the join model. This association profileable/identable already exists"

end

