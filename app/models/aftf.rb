class Aftf < ActiveRecord::Base
	belongs_to :creator, class_name: "User"
	validates :creator, presence: true	
  
	belongs_to :conversation
	validates :conversation, presence: true	

	belongs_to :answer_call, polymorphic: true
	#validates :accepted
	
	#USER who made the call
	def decider
		return self.answer_call.creator if answer_call.class.name == "Conversation"
		return self.answer_call.callable if answer_call.class.name == "Call"
		return nil if answer_call.nil?
	end
	
	def decider_call
		puts " le decider_call =======================================> " +Call.where(callable: self.creator, conversation: self.conversation , parent: self.answer_call).last.inspect.to_s
		return Call.where(callable: self.creator, conversation: self.conversation , parent: self.answer_call).last #dirty =====!!!
	end
	
	MAX_AFTF_PER_CONV = 3
	
	def alive?
		return self.accepted.nil?
	end
	#============================> unicité conversation, creator, alive?=true, 
  	#AFTF S/U
	has_many :aftf_actions, dependent: :destroy
	has_many :supporters, -> { where(aftf_actions: {support: "up"})}, through: :aftf_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(aftf_actions: {support: "down"})}, through: :aftf_actions, source: "creator", class_name: "User"
end
