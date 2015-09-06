class PostAction < ActiveRecord::Base
	#USER who S/U the POST
	belongs_to :creator, :class_name => "User", :foreign_key  => "user_id"
	validates :creator, presence: true
	
	#POST which is S/U
	belongs_to :post
	validates :post, presence: true

	#S or U ?
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
	
	validates_uniqueness_of :user_id, :scope => [:post_id],	:message => "Error on the join model. This post already exists"	
end

