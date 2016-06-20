class AddStatusToObjectActions < ActiveRecord::Migration
  def change
    add_column :object_actions, :status, :string
  end
end
