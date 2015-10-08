class Post < ActiveRecord::Base
	#CONVERSATION
	belongs_to :conversation
	validates :conversation, presence: true	
	
	#USER who wrote the POST
	def creator
		return self.parent.creator if parent_type == "Conversation"
		return self.parent.callable if parent_type == "Call"
	end
	
	#brother calls
	def brother_calls
		return self.parent.child_calls
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
