class Call < ActiveRecord::Base
	include ObjectTransferModule
	
	#check for AFTF which this CALL could have accepted
	before_destroy :cancel_accepted_aftfs, :transfer_down, :merge_alive_aftfs
	def cancel_accepted_aftfs
		brother_aftf.update_attributes(accepted: nil, parent: nil, brother_call: nil) if !brother_aftf.nil?
	end 

	#case with 2 AFTF in the air (one was in the air and the other falls in the air because of destroying its parent)
	def merge_alive_aftfs
		aftfs_to_merge = conversation.aftfs.select{|x| x.creator == callable && x.alive?}
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
		return parent.child_post
	end
	
	#CONVERSATION
	belongs_to :conversation
	validates :conversation, presence: true
		
	#CALL S/U
	has_many :object_actions, as: :object, dependent: :destroy
	has_many :supporters, -> { where(object_actions: {support: "up"})}, through: :object_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(object_actions: {support: "down"})}, through: :object_actions, source: "creator", class_name: "User"
	
	#USER / POTENTIAL USER who is called out
	belongs_to :callable, polymorphic: true
	validates :callable, presence: true	
	
	#AFTF which is eventually linked to this CALL (This CALL has entitled its CALLABLE to answer an AFTF )
	has_many :child_aftfs, as: :parent, class_name: "Aftf"
	has_one :brother_aftf, class_name: "Aftf", foreign_key: "brother_call_id"

	#USER who made the call
	def creator
		return parent.creator if parent_type == "Conversation"
		return parent.callable if parent_type == "Call"
	end
	
	
	validates_uniqueness_of :callable_id, :scope => [:conversation_id, :callable_type, :parent_id, :parent_type], :message => "This (Potential) User is already called out in this conversation..."
	
	#PARENT (CONVERSATION or CALL)
	belongs_to :parent, polymorphic: true
	validates :parent, presence: true	
	has_many :child_calls, as: :parent, class_name: "Call"
	has_one :child_post, as: :parent, class_name: "Post"
	
end
