class AddSweptToObjectActions < ActiveRecord::Migration
  def change
    add_column :object_actions, :swept, :boolean, :default => false
  end
end
