class Conversation < ActiveRecord::Base
	has_many :posts, inverse_of: :conversation
	has_many :callouts
	accepts_nested_attributes_for :posts
	validates :posts, :length => {:minimum => 1, :message=> "At least one post!" }
end
