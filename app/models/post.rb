class Post < ActiveRecord::Base
	belongs_to :conversation
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	
	has_many :post_actions
	has_many :supporters, -> { where(post_actions: {support: "up"})}, through: :post_actions, source: "user", class_name: "User"
	has_many :unsupporters, -> { where(post_actions: {support: "down"})}, through: :post_actions, source: "user", class_name: "User"
	
	validates :title, presence: true
	validates :content, presence: true
	validates :creator, presence: true
	validates :conversation, presence: true
	
	validate :support_vs_creator
	def support_vs_creator
		if supporters.include?(creator) ||  unsupporters.include?(creator) 
			errors.add("You can\'t support or unsupport a post you have written") 
		end
	end
	#validates :creator, uniqueness: {scope: [:conversation]} ... et en plus index à mettre sur la table
end
