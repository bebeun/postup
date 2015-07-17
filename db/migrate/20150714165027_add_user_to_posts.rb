class AddUserToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :creator, index: true
    add_foreign_key :posts, :creators
  end
end
