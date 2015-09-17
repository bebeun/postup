class Conversation < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	has_many :calls, dependent: :destroy
	has_many :aftfs, dependent: :destroy #all the aftf
	
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	validates :creator, presence: true
	
	has_many :child_calls, as: :parent, class_name: "Call"
	has_one :child_post, as: :parent, class_name: "Post"
	has_many :child_aftfs, as: :parent_call, class_name: "Aftf"
	
	def has_content?
		return self.posts.any? || self.calls.any?
	end
	#AFTF which is eventually linked to this CONVERSATION (This CONVERSATION has entitled its CREATOR to answer an AFTF at its beginning )
	
end
