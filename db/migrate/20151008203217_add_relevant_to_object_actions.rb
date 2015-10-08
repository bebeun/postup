class AddRelevantToObjectActions < ActiveRecord::Migration
  def change
    add_column :object_actions, :relevant, :boolean, :default => true
  end
end
