class Profile < ActiveRecord::Base
	#after create: callout by super admin

	belongs_to :profileable, polymorphic: true, class_name: "::Profile"
	#validates_inclusion_of :profileable_type, in: ["User","PotentialUser"]
	
	validates :description, presence: true, allow_blank: false
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This description has already been taken"
	
	belongs_to :category
	validates :category, presence: true
	
	validates_uniqueness_of :category, :scope => [:description],	:message => "This profile (category + description) exists already"

end
