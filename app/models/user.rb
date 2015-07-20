class User < ActiveRecord::Base
	has_many :callouts_users
	has_many :callouts, through: :callouts_users, source: :callout
	has_many :callouts, as: :calloutable

	devise 	:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
	
	has_many :posts, inverse_of: :creator
	
	has_many :profiles, as: :profileable, :validate => true 
	
	validates :name, presence: true
	validates_uniqueness_of :name, :case_sensitive => false, :message => "This name has already been taken"
end	

#Before truc...check via regex description...
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable		
#Callout envoyé

=begin
	# inverse_of: :users ne marche pas avec through, polymorphic
	
	
	
There are a few limitations to inverse_of support:

    They do not work with :through associations.
    They do not work with :polymorphic associations.
    They do not work with :as associations.
    For belongs_to associations, has_many inverse associations are ignored.

Every association will attempt to automatically find the inverse association and set the :inverse_of option heuristically (based on the association name). Most associations with standard names will be supported. However, associations that contain the following options will not have their inverses set automatically:

    :conditions
    :through
    :polymorphic
    :foreign_key
=end