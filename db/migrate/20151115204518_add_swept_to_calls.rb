class AddSweptToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :swept, :boolean, :default => false
  end
end
