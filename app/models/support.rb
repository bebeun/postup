class Support < ActiveRecord::Base
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id", inverse_of: :supports
	validates :creator, presence: true
	
	belongs_to :supportable, polymorphic: true
	validates :supportable, presence: true
	# + qqch pr dire supportable_type = Callout ou Post ?
	# + index ou uniqness sur [supportable_id et supportable_type]
end
