class AddUserToUserActions < ActiveRecord::Migration
  def change
    add_reference :user_actions, :user, index: true
    add_foreign_key :user_actions, :users
  end
end
