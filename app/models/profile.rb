class Profile < ActiveRecord::Base
	# before_validation do
		# puts "=============================> before validation Profile"
		# puts "=========>"+profileable_id.to_s+" - "+identable_id.to_s+" - "+identable_type.to_s+" - "+profileable_type.to_s
	# end
	# after_validation do
		# puts "=============================> after validation Profile"
		# puts "=========>"+profileable_id.to_s+" - "+identable_id.to_s+" - "+identable_type.to_s+" - "+profileable_type.to_s
	# end
	# before_save do
		# puts "=============================> before save Profile"
	# end
	# after_save do
		# puts "=============================> after save Profile"
	# end
	#after create: callout by super admin

	belongs_to :profileable, polymorphic: true, class_name: "::Profile"
	#validates_inclusion_of :profileable_type, in: ["User","PotentialUser"]
		
	belongs_to :identable, polymorphic: true, class_name: "::Profile"
	#validates_inclusion_of :profileable_type, in: ["User","PotentialUser"]
	
	validates_uniqueness_of :profileable_id, :scope => [:identable_id, :identable_type,:profileable_type,],	:message => "Error on the join model. This association profileable/identable already exists"

end

