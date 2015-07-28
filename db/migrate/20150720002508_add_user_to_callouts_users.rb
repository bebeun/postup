class AddUserToCalloutsUsers < ActiveRecord::Migration
  def change
    add_reference :callouts_users, :user, index: true
    add_foreign_key :callouts_users, :users
  end
end
