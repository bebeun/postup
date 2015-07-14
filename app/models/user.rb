class User < ActiveRecord::Base
	has_many :posts
	has_many :callouts
	
	validates :name, presence: true
end
