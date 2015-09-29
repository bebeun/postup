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
	
	#creator must support at least its own post
	validate :creator_is_supporter	
	def creator_is_supporter
	if !self.supporters.include?(self.creator)
			errors.add(:callable, "Creator must support its own post...") 
		end
	end

	#POST S/U
	has_many :post_actions, dependent: :destroy
	has_many :supporters, -> { where(post_actions: {support: "up"})}, through: :post_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(post_actions: {support: "down"})}, through: :post_actions, source: "creator", class_name: "User"
	
	#POST content
	validates :title, presence: true
	validates :content, presence: true
	
	#PARENT (CONVERSATION or CALL)
	belongs_to :parent, polymorphic: true
	validates :parent, presence: true	
end
