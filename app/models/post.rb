class Post < ActiveRecord::Base
	include ObjectTransferModule
			
	#CONVERSATION
	belongs_to :conversation
	validates :conversation, presence: true	
	
	#USER
	belongs_to :creator, class_name: "User", foreign_key: "creator_id"
	validates :creator, presence: true	
	
	#CALL
	has_one :call, class_name: "Call", inverse_of: :post
	
	#POST S/U
	has_many :object_actions, as: :object, dependent: :destroy
	has_many :supporters, -> { where(object_actions: {support: "up", swept: false})}, through: :object_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(object_actions: {support: "down", swept: false})}, through: :object_actions, source: "creator", class_name: "User"

	
	#POST content
	validates :title, presence: true
	validates :content, presence: true

	
end
