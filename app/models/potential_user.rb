class PotentialUser < ActiveRecord::Base
	has_many :callins, as: :callable, class_name: "Call"
	
	has_one :twitter, as: :owner, class_name: "Twitter"
	has_one :facebook, as: :owner, class_name: "Facebook"
	
	def profile
		return self.twitter if self.twitter
		return self.facebook if self.facebook
	end
	
	# validate :one_profile
	# def one_profile
		# errors.add(:user, "There must be one and only one profile") if profile.nil? 
	# end
	
	has_many :user_actions_supporters, as: :supportable, :class_name => "UserAction"
	
	def supporters
		self.user_actions_supporters.select{|x| x.support == "up"}.collect{|x| x.creator}
	end
	
	def unsupporters
		self.user_actions_supporters.select{|x| x.support == "down"}.collect{|x| x.creator}
	end
	
	def is_potential_user?
		true
	end
	def is_user?
		false
	end
	
end

