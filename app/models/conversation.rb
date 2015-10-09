class Conversation < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	has_many :calls, dependent: :destroy
	has_many :aftfs, dependent: :destroy #all the aftf
	
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	validates :creator, presence: true
	
	has_many :child_calls, as: :parent, class_name: "Call"
	has_one :child_post, as: :parent, class_name: "Post"
	has_many :answer_aftfs, as: :answer_call, class_name: "Aftf"
	
	def has_content?
		return posts.any? || calls.any?
	end
	
	def title
		if has_content?
			if posts.any? 
				return posts.first.title
			else
				user =  calls.first.callable
				user.class.name == "User" ? name = user.name : name = user.profile.class.name+" : "+user.profile.description
				return calls.first.supporters.collect{|x| x.name }.join(" + ").to_s+" >>  "+name
			end
		else
			return "This is a new conversation! "
		end
	
	end
	
	
	#AFTF which is eventually linked to this CONVERSATION (This CONVERSATION has entitled its CREATOR to answer an AFTF at its beginning )
	
end
