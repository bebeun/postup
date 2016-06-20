class AddConversationToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :conversation, index: true
    add_foreign_key :calls, :conversations
  end
end
