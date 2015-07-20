class PotentialUser < ActiveRecord::Base
	has_many :callouts, as: :calloutable	 
	
	has_one :profile, as: :profileable, :validate => true
	validates :profile, presence: true
end
	#after create: callout by super admin
	