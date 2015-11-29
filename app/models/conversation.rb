class Conversation < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	accepts_nested_attributes_for :posts, limit: 1
	validates :posts, length: { minimum: 1}
	
	has_many :calls, dependent: :destroy	
	
	belongs_to :creator, :class_name => 'User', :foreign_key  => "creator_id"
	validates :creator, presence: true
	
	validates :title, presence: true
end
