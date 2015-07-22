class AddUserToPosts < ActiveRecord::Migration
  def change
	#add_reference :posts, :creator, references: :users, , index: true
    add_reference :posts, :creator, index: true
    add_foreign_key :posts, :creators
	#add_foreign_key :posts, :users, name: :creator
  end
end
