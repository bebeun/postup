class Callout < ActiveRecord::Base
	belongs_to :conversation
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	belongs_to :target, :class_name => 'User', :foreign_key  => "target_id"
	
	validates :conversation, presence: true
	validates :creator, presence: true
	validates :target, presence: true
	
	has_many :supports, as: :supportable
	
	validate :target_vs_creator
	def target_vs_creator
		if target == creator
			errors.add(:target, "You can\'t call out yourself") 
		end
	end
	
	validates :target, uniqueness: {scope: [:creator, :conversation]}
end
