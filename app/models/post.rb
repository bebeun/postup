class Post < ActiveRecord::Base
	belongs_to :conversation, inverse_of: :posts
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id", inverse_of: :posts
	
	validates :title, presence: true
	validates :content, presence: true
	validates :creator, presence: true
	validates :conversation, presence: true
	
	has_many :supports, as: :supportable
	
	#validates :creator, uniqueness: {scope: [:conversation]} ... et en plus index à mettre sur la table
end
