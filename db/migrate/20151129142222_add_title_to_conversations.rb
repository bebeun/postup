class AddTitleToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :title, :string
  end
end
