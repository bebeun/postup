class Conversation < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	has_many :calls, dependent: :destroy
	
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	validates :creator, presence: true
		
	def has_content?
		return posts.any? # || calls.any?
	end
	
	def title
		if has_content?
			return posts.first.title
		else
			return "This is a new conversation! "
		end
	
	end
end
