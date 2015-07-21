class Conversation < ActiveRecord::Base
	has_many :posts
	has_many :calls
end
