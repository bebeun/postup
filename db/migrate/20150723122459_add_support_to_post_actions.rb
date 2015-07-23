class AddSupportToPostActions < ActiveRecord::Migration
  def change
    add_column :post_actions, :support, :string, :default => "up"
  end
end
