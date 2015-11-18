class AddDeclinedToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :declined, :boolean, :default => false
  end
end
