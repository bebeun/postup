class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise 	:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
		
	
	has_many :callouts, :class_name => "Call", :foreign_key => "creator_id"
	
	has_many :callins, as: :callable, class_name: "Call"
	has_many :profiles, as: :profileable, :validate => true #user qui entre son profil fb lui même
	has_many :posts
	validates :name, presence: true
	validates_uniqueness_of :name, :case_sensitive => false, :message => "This name has already been taken"
	
end
