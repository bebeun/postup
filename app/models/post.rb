class Post < ActiveRecord::Base
	belongs_to :conversation
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	
	validates :title, presence: true
	validates :content, presence: true
	validates :creator, presence: true
	validates :conversation, presence: true
	
	#validates :creator, uniqueness: {scope: [:conversation]} ... et en plus index à mettre sur la table
end
