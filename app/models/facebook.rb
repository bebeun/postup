class Facebook < ActiveRecord::Base
	#DESCRIPTION
	validates :description, presence: true, allow_blank: false
	before_save :downcase_description
    def downcase_description
		self.description = description.downcase
    end
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This Facebook description has already been taken"
	
	#FB ACTIVATIONS
	has_many :facebook_activations
	
	#USER OR POTENTIAL it belongs to
	belongs_to :owner, polymorphic: true

	# Sends activation email.
	def send_activation_email
		PostMailer.post_validation(self).deliver_now
	end
	
	def is_available_for(user)
		return !user.has_this_profile?(self) && !user.has_pending_facebook_activations?(self) && !user.has_been_reported_for_facebook?(self)
	end
end
