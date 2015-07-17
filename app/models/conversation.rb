class Conversation < ActiveRecord::Base
	has_many :posts, inverse_of: :conversation
	has_many :callouts, inverse_of: :conversation
end
