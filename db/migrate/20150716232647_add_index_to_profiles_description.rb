class AddIndexToProfilesDescription < ActiveRecord::Migration
  def change
	add_index :profiles, :description, :unique => true
  end
end
