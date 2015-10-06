class Call < ActiveRecord::Base
	#check for AFTF which this CALL could have accepted
	before_destroy :cancel_accepted_aftfs, :merge_alive_aftfs
	def cancel_accepted_aftfs
		self.parent.answer_aftfs.select{|x| x.creator == self.callable && x.accepted}.each do |x|
			x.update_attributes(accepted: nil, answer_call: nil)
		end
	end 
	
	#case with 2 AFTF in the air (one was in the air and the other falls in the air because of destroying its answer_call)
	def merge_alive_aftfs
		aftfs_to_merge = self.conversation.aftfs.select{|x| x.creator == self.callable && x.alive?}
		if aftfs_to_merge.many?
			eldest_aftf = aftfs_to_merge.first
			aftfs_to_merge -= [eldest_aftf]
			aftfs_to_merge.each do |x|
				x.supporters.each{|y| eldest_aftf.supporters << y if (!eldest_aftf.supporters.include?(y) && !eldest_aftf.unsupporters.include?(y))}
				x.unsupporters.each{|y| eldest_aftf.unsupporters << y if (!eldest_aftf.supporters.include?(y) && !eldest_aftf.unsupporters.include?(y))} 
				x.destroy
			end
		end
	end 
	

	
	#brother post
	def brother_post
		return self.parent.child_post
	end
	
	#CONVERSATION
	belongs_to :conversation
	validates :conversation, presence: true
	
	#CALL S/U
	has_many :call_actions, dependent: :destroy
	has_many :supporters, -> { where(call_actions: {support: "up"})}, through: :call_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(call_actions: {support: "down"})}, through: :call_actions, source: "creator", class_name: "User"
	#validates :supporters, :length => {:minimum => 1, :message => "At least one supporter is required" }	
	

	
	#USER / POTENTIAL USER who is called out
	belongs_to :callable, polymorphic: true
	validates :callable, presence: true	
	
	#AFTF which is eventually linked to this CALL (This CALL has entitled its CALLABLE to answer an AFTF )
	has_many :answer_aftfs, as: :answer_call, class_name: "Aftf"
	has_one :authorised_aftf, class_name: "Aftf", foreign_key: "decider_call_id"

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
	
	validates_uniqueness_of :callable_id, :scope => [:conversation_id, :callable_type, :parent_id, :parent_type], :message => "This (Potential) User is already called out in this conversation..."
	
	#PARENT (CONVERSATION or CALL)
	belongs_to :parent, polymorphic: true
	validates :parent, presence: true	
	has_many :child_calls, as: :parent, class_name: "Call"
	has_one :child_post, as: :parent, class_name: "Post"
	
end
