class Post < ActiveRecord::Base
	include ObjectTransferModule
	
	def status
		return "swept" if self.object_actions.select{|oa| oa.status == "swept"}.any? && !self.object_actions.select{|oa| oa.status == "active"}.any?
		return "active" if self.object_actions.select{|oa| oa.status == "active"}.any?
		return "removed" if !self.object_actions.select{|oa| oa.status == "swept"}.any? && !self.object_actions.select{|oa| oa.status == "active"}.any? && self.object_actions.select{|oa| oa.status == "removed"}.any?
	end	
	
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
	has_many :supporters, -> { where(object_actions: {support: "up", status: "active"})}, through: :object_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(object_actions: {support: "down", status: "active"})}, through: :object_actions, source: "creator", class_name: "User"

	
	#POST content
	validates :title, presence: true
	validates :content, presence: true

	
end
