class Support < ActiveRecord::Base
	belongs_to :supportable, polymorphic: true
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id" 
	
	validates :creator, presence: true
	validates :supportable, presence: true
end
