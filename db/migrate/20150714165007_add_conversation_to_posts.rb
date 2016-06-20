class AddConversationToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :conversation, index: true
    add_foreign_key :posts, :conversations
  end
end
