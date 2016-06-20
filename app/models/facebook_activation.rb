class FacebookActivation < ActiveRecord::Base
	#TOKEN
	before_create :create_token
	# Creates and assigns the activation token and digest.
    def create_token
		self.token  =  SecureRandom.urlsafe_base64(64, false)
    end	
	
	#USER who requested this Facebook
	belongs_to :creator, :class_name => 'User', :foreign_key  => "user_id"
	validates :creator, presence: true
	
	#FB profile concerned
	belongs_to :facebook
	validates :facebook, presence: true
	
	#Number of mails sent to the user who requested the FB
	validates :mailnumber, presence: true, numericality: { less_than_or_equal_to: 5 }
	
	validates_uniqueness_of :user_id, scope: :facebook_id, message: "We have already sent a mail to your Facebook profile..."
end
