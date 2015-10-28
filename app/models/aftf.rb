class Aftf < ActiveRecord::Base
	belongs_to :creator, class_name: "User"
	validates :creator, presence: true	
  
	belongs_to :conversation
	validates :conversation, presence: true	

	belongs_to :parent, polymorphic: true
	#attribut accepted  => is true, false or nil
	belongs_to :brother_call, class_name: "Call", inverse_of: :brother_aftf
	
	#USER who made the call
	def decider
		return parent.creator if parent.class.name == "Conversation"
		return parent.callable if parent.class.name == "Call"
		return nil if parent.nil?
	end
		
	MAX_AFTF_PER_CONV = 3
	
	def alive?
		return accepted.nil?
	end
	
	def to_be_displayed?
		(accepted.nil?) ? (return true) : (return !accepted)
	end
	
	validates_uniqueness_of :creator_id, :scope => [:conversation_id], conditions: -> { where(accepted: nil) }  
	
  	#AFTF S/U
	has_many :object_actions, as: :object, dependent: :destroy
	has_many :supporters, -> { where(object_actions: {support: "up"})}, through: :object_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(object_actions: {support: "down"})}, through: :object_actions, source: "creator", class_name: "User"
end
