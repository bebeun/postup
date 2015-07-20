class Profile < ActiveRecord::Base
	#after create: callout by super admin

	belongs_to :profileable, polymorphic: true, class_name: "::Profile"
	validates :description, presence: true, allow_blank: false
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This description has already been taken"
end
