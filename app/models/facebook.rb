class Facebook < ActiveRecord::Base
	has_one :profile, :as => :identable
	
	validates :description, presence: true, allow_blank: false
	before_save   :downcase_description
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This Facebook description has already been taken"
	
	has_many :facebook_activations
	
	# Sends activation email.
	def send_activation_email
		PostMailer.post_validation(self).deliver_now
	end
	
  # Converts description to all lower-case.
    def downcase_description
      self.description = description.downcase
    end
end
