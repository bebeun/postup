class Category < ActiveRecord::Base
	has_many :profiles
	validates :origin, presence: true
	validates_inclusion_of :origin, in: ["FB","TW"]
end
