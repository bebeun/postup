class Conversation < ActiveRecord::Base
	has_many :posts, inverse_of: :conversation
	has_many :callouts, inverse_of: :conversation
	#accepts_nested_attributes_for :posts
	#accepts_nested_attributes_for :callouts
	#validates :posts, :length => {:minimum => 1, :message=> "At least one post!" }
end
