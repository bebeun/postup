class Facebook < ActiveRecord::Base
	# before_validation do
		# puts "=============================> before validation Facebook"
	# end
	# before_save do
		# puts "=============================> before save Facebook"
	# end
	# after_save do
		# puts "=============================> after save Facebook"
	# end
	
	has_one :profile, :as => :identable
	
	validates :description, presence: true, allow_blank: false
	validates_uniqueness_of :description, :case_sensitive => false, :message => "This Facebook description has already been taken"
	
	has_many :facebook_activations
	
	# Sends activation email.
	def send_activation_email
		PostMailer.post_validation(self).deliver_now
	end
end
