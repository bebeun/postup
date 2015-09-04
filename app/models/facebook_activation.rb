class FacebookActivation < ActiveRecord::Base
	before_create :create_token
	belongs_to :user
	belongs_to :facebook
	validates_uniqueness_of :user_id, scope: :facebook_id, message: "We have already sent a mail to your Facebook profile..."
	validates :mailnumber, presence: true, numericality: { less_than_or_equal_to: 5 }

	# Creates and assigns the activation token and digest.
    def create_token
		self.token  = SecureRandom.urlsafe_base64(64, false)
    end
end