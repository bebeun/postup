class PostAction < ActiveRecord::Base
	belongs_to :user
	belongs_to :post, :validate => true 
	validates_uniqueness_of :user_id, :scope => [:post_id],	:message => "Error on the join model. This post already exists"
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
end


#erreur à mettre sur un model displayed (post ou user ou conversation)