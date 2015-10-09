class Twitter < ActiveRecord::Base
	#DESCRIPTION
	validates :description, presence: true, allow_blank: false
	before_save :downcase_description
    def downcase_description
		description = description.downcase
    end
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This Twitter description has already been taken"
	
	#USER it belongs to
	belongs_to :owner, polymorphic: true

end
