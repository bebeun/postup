class Call < ActiveRecord::Base
	belongs_to :conversation
	#belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	has_many :call_actions
	has_many :creators, through: :call_actions, source: "user", class_name: "User"
	#mini un créateur...
	
	belongs_to :callable, polymorphic: true, class_name: "::Callout", :validate => true 
	# + qqch pr dire callable_type = User ou PotentialUser ?
	
	validates :conversation, presence: true
	validates :callable, presence: true
	
	validate :callable_vs_creator
	def callable_vs_creator
		if creators.include?(callable)
			errors.add("You can\'t call out yourself") 
		end
	end
	
	validates_uniqueness_of :callable_id, :scope => [:conversation_id, :callable_type], :message => "This (Potential) User is already called out in this conversation..."
end
