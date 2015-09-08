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
	belongs_to :callable, polymorphic: true
	#validates_inclusion_of :callable_type, in: ["User","PotentialUser"]
	validates :callable, presence: true	

	#USER who made the call
	def creator
		return self.parent.creator if parent_type == "Conversation"
		return self.parent.callable if parent_type == "Call"
	end
	
	validate :callable_vs_creator	
	def callable_vs_creator
	if callable == creator
			errors.add(:callable, "You can t support call out yourself...") 
		end
	end
	
	validates_uniqueness_of :callable_id, :scope => [:conversation_id, :callable_type], :message => "This (Potential) User is already called out in this conversation..."
	
	#PARENT (CONVERSATION or CALL)
	belongs_to :parent, polymorphic: true
	validates :parent, presence: true	
	has_many :child_calls, as: :parent, class_name: "Call"
	has_one :child_post, as: :parent, class_name: "Post"
	
	#if call has given a post, the s/u have been switched to the post. the call can't be s/u anymore
	def can_be_s_or_u?
		return self.child_post.nil?
	end
	
	#Critical situation: a call has given children ( child_calls, child_post )
	#one shouldn't unsupport (which could lead to destroy it) or destroy it
	#(in fact, to check for child_post is redundant with "can_be_s_or_u?")
	def should_not_be_unsupported_or_destroyed_by(user)
		return self.supporters.count == 1 && self.supporters.include?(user) && (self.child_calls.any? || !self.child_post.nil?)
	end
end
