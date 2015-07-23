class User < ActiveRecord::Base
	devise 	:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

	has_many :profiles, as: :profileable, :validate => true 

	has_many :call_actions
	has_many :callouts, through: :call_actions, source: "call", class_name: "Call"
	
	has_many :post_actions
	has_many :postsupports, through: :post_actions, source: "post", class_name: "Post"

	has_many :callins, as: :callable, class_name: "Call"
	
	has_many :profiles, as: :profileable, :validate => true #user qui entre son profil fb lui même
	
	has_many :posts
	has_many :posts, inverse_of: :creator
	
	validates :name, presence: true
	validates_uniqueness_of :name, :case_sensitive => false, :message => "This name has already been taken"
end	
