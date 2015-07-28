class AddCalloutToCalloutsUsers < ActiveRecord::Migration
  def change
    add_reference :callouts_users, :callout, index: true
    add_foreign_key :callouts_users, :callouts
  end
end
