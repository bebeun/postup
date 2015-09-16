class Conversation < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	has_many :calls, dependent: :destroy
	
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	validates :creator, presence: true
	
	has_many :child_calls, as: :parent, class_name: "Call"
	has_one :child_post, as: :parent, class_name: "Post"
	
	def has_content?
		return self.posts.any? || self.calls.any?
	end
	
	has_many :aftfs, dependent: :destroy
end
