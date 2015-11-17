class Call < ActiveRecord::Base
	

	#CONVERSATION
	belongs_to :conversation
	validates :conversation, presence: true
	
	#POST
	belongs_to :post, class_name: "Post", inverse_of: :call
		
	#CALL S/U
	has_many :object_actions, as: :object, dependent: :destroy
	has_many :supporters, -> { where(object_actions: {support: "up", swept: false})}, through: :object_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(object_actions: {support: "down", swept: false})}, through: :object_actions, source: "creator", class_name: "User"
	
	#USER / POTENTIAL USER who is called out
	belongs_to :callable, polymorphic: true
	validates :callable, presence: true	

	#USER who made the call
	belongs_to :creator, class_name: "User", foreign_key: "creator_id"
	validates :creator, presence: true	
	
	validates_uniqueness_of :callable_id, :scope => [:conversation_id, :callable_type], conditions: -> { where(swept: false) }, :message => "This (Potential) User is already called out in this conversation..."
end
