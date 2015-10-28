class Post < ActiveRecord::Base
	include ObjectTransferModule
	
	def to_be_displayed?
		return true
	end
	
	#CONVERSATION
	belongs_to :conversation
	validates :conversation, presence: true	
	before_destroy :transfer_down
	
	#USER who wrote the POST
	def creator
		return parent.creator if parent_type == "Conversation"
		return parent.callable if parent_type == "Call"
	end
	
	#brother calls
	def brother_calls
		return parent.child_calls
	end
	

	#POST S/U
	has_many :object_actions, as: :object, dependent: :destroy
	has_many :supporters, -> { where(object_actions: {support: "up"})}, through: :object_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(object_actions: {support: "down"})}, through: :object_actions, source: "creator", class_name: "User"
	
	#POST content
	validates :title, presence: true
	validates :content, presence: true
	
	#PARENT (CONVERSATION or CALL)
	belongs_to :parent, polymorphic: true
	validates :parent, presence: true	
end
