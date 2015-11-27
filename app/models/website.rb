class Website < ActiveRecord::Base
	#DESCRIPTION / EXTENSION
	validates :description, presence: true, allow_blank: false
	
	before_save :downcase
	
    def downcase
		self.description = description.downcase
    end
	
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This website already exists..."
	
	#USER it belongs to
	belongs_to :owner, polymorphic: true
end
