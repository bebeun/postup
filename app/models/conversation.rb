class Conversation < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	has_many :calls, dependent: :destroy
	
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	validates :creator, presence: true
	
	#Mini 1 POST : to be added
end
