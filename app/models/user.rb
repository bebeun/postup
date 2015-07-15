class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise 	:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
			
	has_many :posts
	has_many :callouts
	
	validates :name, presence: true
	validates_uniqueness_of :name, :case_sensitive => false, :message => "This name has already been taken"
	
end
