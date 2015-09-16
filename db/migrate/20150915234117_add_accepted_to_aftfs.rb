class AddAcceptedToAftfs < ActiveRecord::Migration
  def change
    add_column :aftfs, :accepted, :boolean
  end
end
