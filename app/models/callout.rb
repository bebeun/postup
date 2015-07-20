class Callout < ActiveRecord::Base
	has_many :callouts_users
	has_many :users, through: :callouts_users
	
	belongs_to :calloutable, polymorphic: true, class_name: "::Callout", :validate => true 
	validates_uniqueness_of :calloutable_id, :scope => [:user_id, :conversation_id, :calloutable_type]
	validates :calloutable, presence: true	
	
	belongs_to :conversation	
	validates :conversation, presence: true
end

	# + qqch pr dire calloutable_type = User ou PotentialUser ?	
	#validate :calloutable_vs_creator
	#def calloutable_vs_creator
	#	if calloutable == creator
	#		errors.add(:target, "You can\'t call out yourself") 
	#	end
	#end
	# revoir les inverse of
	#validates :calloutable, uniqueness: {scope: [:creator, :conversation]} ....ne voit que uniqness id et confond les id même avec des types différents