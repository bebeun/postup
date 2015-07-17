class Profile < ActiveRecord::Base
	belongs_to :profileable, polymorphic: true
	validates :description, presence: true
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This description has already been taken"
end
