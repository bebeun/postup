class PotentialUser < ActiveRecord::Base
	# before_validation do
		# puts "=============================> before validation PotentialUser"
	# end
	has_many :callins, as: :callable, class_name: "Call"
	has_one :profile, as: :profileable #, :validate => true
	validates :profile, presence: true
end
	#after create: callout by super admin
	
