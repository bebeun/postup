class PostAction < ActiveRecord::Base
	belongs_to :creator, :class_name => "User", :foreign_key  => "user_id"
	validates :creator, presence: true
	
	belongs_to :post, :validate => true 
	validates :post, presence: true

	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
	
	validates_uniqueness_of :user_id, :scope => [:post_id],	:message => "Error on the join model. This post already exists"	
end

