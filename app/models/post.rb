class Post < ActiveRecord::Base
	belongs_to :conversation, inverse_of: :posts
	belongs_to :creator, :class_name => 'User', :foreign_key  => "user_id" #idéalement il faudra avoir une colonne creator_id...
	
	validates :title, presence: true
	validates :content, presence: true
	validates :creator, presence: true
	validates :conversation, presence: true
	
	has_many :supports, as: :supportable
end
