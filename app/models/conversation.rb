class Conversation < ActiveRecord::Base
	has_many :posts
	has_many :calls
	
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	validates :creator, presence: true
end
