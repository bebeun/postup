class Participation < ActiveRecord::Base
	#PARTICIPATION
	belongs_to :conversation
	validates :conversation, presence: true
	
	#PARENT (CONVERSATION or CALL)
	belongs_to :parent, polymorphic: true
	validates :parent, presence: true

	has_one :post, dependent: :destroy, inverse_of: :participation
	has_many :calls, dependent: :destroy, inverse_of: :participation
	
	accepts_nested_attributes_for :post, :calls
	
	validates_associated :post, :calls
	
	validate :has_content?
	def has_content?
		return !self.post.nil? || self.calls.any?  #marche pas !!
	end
	
	#USER who initiated the Participation
	def creator
		return self.parent.creator if parent_type == "Conversation"
		return self.parent.callable if parent_type == "Call"
	end
	
end
