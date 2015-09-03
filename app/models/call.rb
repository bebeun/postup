class Call < ActiveRecord::Base

	belongs_to :conversation
	validates :conversation, presence: true
	
	has_many :call_actions
	has_many :supporters, -> { where(call_actions: {support: "up"})}, through: :call_actions, source: "user", class_name: "User"
	has_many :unsupporters, -> { where(call_actions: {support: "down"})}, through: :call_actions, source: "user", class_name: "User"
	validates :supporters, :length => {:minimum => 1, :message=>"At least one supporter is required" }	
	
	belongs_to :callable, polymorphic: true, class_name: "::Callout", :validate => true 
	#validates_inclusion_of :callable_type, in: ["User","PotentialUser"]
	validates :callable, presence: true	

	validate :callable_vs_supporters
	def callable_vs_supporters
	if supporters.include?(callable) || unsupporters.include?(callable) 
			errors.add(:callable, "You can t support or unsupport your own callout") 
		end
	end
	
	validates_uniqueness_of :callable_id, :scope => [:conversation_id, :callable_type], :message => "This (Potential) User is already called out in this conversation..."
end
