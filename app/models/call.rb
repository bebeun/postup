class Call < ActiveRecord::Base
	#CONVERSATION
	belongs_to :conversation
	validates :conversation, presence: true
	
	#CALL S/U
	has_many :call_actions, dependent: :destroy
	has_many :supporters, -> { where(call_actions: {support: "up"})}, through: :call_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(call_actions: {support: "down"})}, through: :call_actions, source: "creator", class_name: "User"
	validates :supporters, :length => {:minimum => 1, :message => "At least one supporter is required" }	
	
	#USER / POTENTIAL USER who is called out
	belongs_to :callable, polymorphic: true, :validate => true 
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
