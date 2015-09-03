class PotentialUser < ActiveRecord::Base
	has_many :callins, as: :callable, class_name: "Call"
	
	has_one :profile, as: :profileable #, :validate => true
	validates :profile, presence: true
	
	has_many :user_actions_supporters, as: :supportable, :class_name => "UserAction"
	
	def supporters
		self.user_actions_supporters.select{|x| x.support == "up"}.collect{|x| x.user}
	end
	
	def unsupporters
		self.user_actions_supporters.select{|x| x.support == "down"}.collect{|x| x.user}
	end
	
	def is_potential_user?
		true
	end
	def is_user?
		false
	end
	
end

