class Aftf < ActiveRecord::Base
	belongs_to :creator, class_name: "User"
	validates :creator, presence: true	
  
	belongs_to :conversation
	validates :conversation, presence: true	

	belongs_to :parent_call, polymorphic: true
	#validates :accepted
	
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
