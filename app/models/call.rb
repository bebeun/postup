class Call < ActiveRecord::Base
	belongs_to :conversation
	
	has_many :call_actions
	has_many :creators, through: :call_actions, source: "user", class_name: "User"
	validates :creators, :length => {:minimum => 1, :message=>"At least one creator is required" }	
	
	belongs_to :callable, polymorphic: true, class_name: "::Callout", :validate => true 
	#validates_inclusion_of :callable_type, in: ["User","PotentialUser"]
	validates :callable, presence: true	
	
	validates :conversation, presence: true

	validate :callable_vs_creator
	def callable_vs_creator
		if creators.include?(callable)
			errors.add("You can\'t call out yourself") 
		end
	end
	
	validates_uniqueness_of :callable_id, :scope => [:conversation_id, :callable_type], :message => "This (Potential) User is already called out in this conversation..."
end
