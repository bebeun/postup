class CalloutsUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :callout
	validates_uniqueness_of :user_id, :scope => [:callout_id]
end


#validates :type, presence: true, 
#validates :type, :inclusion=> { :in => ["up", "down"] }
#validates_uniqueness_of :user_id, :scope => [:callout_id]