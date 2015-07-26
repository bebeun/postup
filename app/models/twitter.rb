class Twitter < ActiveRecord::Base
	# before_validation do
		# puts "=============================> before validation Twitter"
	# end
	# before_save do
		# puts "=============================> before save Twitter"
	# end
	# after_save do
		# puts "=============================> after save Twitter"
	# end
	has_one :profile, :as => :identable
	
	validates :description, presence: true, allow_blank: false
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This Twitter description has already been taken"
end
