class Callout < ActiveRecord::Base
	belongs_to :conversation, inverse_of: :callouts
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id", inverse_of: :callouts
	
	belongs_to :calloutable, polymorphic: true, class_name: "::Callout"
	# + qqch pr dire calloutable_type = User ou PotentialUser ?
	
	validates :conversation, presence: true
	validates :creator, presence: true
	validates :calloutable, presence: true
	
	has_many :supports, as: :supportable
	
	validate :calloutable_vs_creator
	def calloutable_vs_creator
		if calloutable == creator
			errors.add(:target, "You can\'t call out yourself") 
		end
	end
	
	validates :calloutable, uniqueness: {scope: [:creator, :conversation]}
end
