class Callout < ActiveRecord::Base
	belongs_to :conversation
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	belongs_to :target, :class_name => 'User', :foreign_key  => "target_id"
	
	validates :conversation, presence: true
	validates :creator, presence: true
	validates :target, presence: true
	
	has_many :supports, as: :supportable
end
