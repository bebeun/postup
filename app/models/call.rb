class Call < ActiveRecord::Base
	belongs_to :conversation
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	
	belongs_to :callable, polymorphic: true, class_name: "::Callout", :validate => true 
	# + qqch pr dire callable_type = User ou PotentialUser ?
	
	validates :conversation, presence: true
	validates :creator, presence: true
	validates :callable, presence: true
	
	validate :callable_vs_creator
	def callable_vs_creator
		if callable == creator
			errors.add(:target, "You can\'t call out yourself") 
		end
	end
	
	validates_uniqueness_of :callable_id, :scope => [:creator_id, :conversation_id, :callable_type]
end

	#validates :callable, uniqueness: {scope: [:creator, :conversation]} ....ne voit que uniqness id et confond les id même avec des types différents