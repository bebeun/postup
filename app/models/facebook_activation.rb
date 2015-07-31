class FacebookActivation < ActiveRecord::Base
	belongs_to :user
	belongs_to :facebook
	validates_uniqueness_of :user_id, scope: :facebook_id, conditions: -> { where("created_at > ?", 2.minutes.ago) }, message: "We have already sent a mail to your Facebook profile..."
end
