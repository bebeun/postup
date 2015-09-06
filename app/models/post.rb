class Post < ActiveRecord::Base
	#CONVERSATION
	belongs_to :conversation
	validates :conversation, presence: true	
	
	#USE who wrote the POST
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	validates :creator, presence: true	
	
	#POST S/U
	has_many :post_actions, dependent: :destroy
	has_many :supporters, -> { where(post_actions: {support: "up"})}, through: :post_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(post_actions: {support: "down"})}, through: :post_actions, source: "creator", class_name: "User"
	
	#POST content
	validates :title, presence: true
	validates :content, presence: true
end
