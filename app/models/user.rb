class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise 	:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
		
	has_many :supports, inverse_of: :creator
	has_many :posts, inverse_of: :creator
	has_many :callouts, inverse_of: :creator
	has_many :callouts, as: :calloutable
	has_many :profiles, as: :profileable, :validate => true #user qui entre son profil fb lui même
	
	validates :name, presence: true
	validates_uniqueness_of :name, :case_sensitive => false, :message => "This name has already been taken"
	
end
