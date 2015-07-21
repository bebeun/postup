class PotentialUser < ActiveRecord::Base
	has_many :callins, as: :callable, class_name: "Call"
	has_one :profile, as: :profileable, :validate => true
	validates :profile, presence: true
end
