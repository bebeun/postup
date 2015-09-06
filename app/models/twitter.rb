class Twitter < ActiveRecord::Base
	#DESCRIPTION
	validates :description, presence: true, allow_blank: false
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This Twitter description has already been taken"
	
	#USER it belongs to
	belongs_to :owner, polymorphic: true
end
