class PotentialUser < ActiveRecord::Base
	has_many :callouts, as: :calloutable	  
	has_one :profile, as: :profileable
end
