class Post < ActiveRecord::Base
	belongs_to :conversation
	validates :conversation, presence: true	
	
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	validates :creator, presence: true	
	
	has_many :post_actions
	has_many :supporters, -> { where(post_actions: {support: "up"})}, through: :post_actions, source: "creator", class_name: "User"
	has_many :unsupporters, -> { where(post_actions: {support: "down"})}, through: :post_actions, source: "creator", class_name: "User"
	
	validates :title, presence: true
	validates :content, presence: true
end
