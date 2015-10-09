class Post < ActiveRecord::Base
	#CONVERSATION
	belongs_to :conversation
	validates :conversation, presence: true	
	before_destroy :transfer_post_s_u_down
	
	def transfer_post_s_u_up
		if parent_type == "Call"
			parent.supporters.each{|y| supporters << y if (!supporters.include?(y) && !unsupporters.include?(y))}
			parent.unsupporters.each{|y| unsupporters << y if (!supporters.include?(y) && !unsupporters.include?(y))} 
			ObjectAction.where(object: parent).destroy_all
		end
	end
	
	def transfer_post_s_u_down
		if parent_type == "Call"
			supporters.each{|y| parent.supporters << y if (!parent.supporters.include?(y) && !parent.unsupporters.include?(y))}
			unsupporters.each{|y| parent.unsupporters << y if (!parent.supporters.include?(y) && !parent.unsupporters.include?(y))} 
			ObjectAction.where(object: self).destroy_all
			parent.creator.supports(parent) 
			(!parent.authorised_aftf.nil? ) ? (parent.callable.supports(parent)) : (parent.callable.remove(parent))
		end
	end
	
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
