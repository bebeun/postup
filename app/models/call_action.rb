class CallAction < ActiveRecord::Base
	belongs_to :user
	belongs_to :call
	validates_uniqueness_of :user_id, :scope => [:call_id],	:message => "Error on the join model. This callout already exists"
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
end

#erreur à mettre sur un model displayed (call ou user ou conversation)