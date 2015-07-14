class AddConversationToCallouts < ActiveRecord::Migration
  def change
    add_reference :callouts, :conversation, index: true
    add_foreign_key :callouts, :conversations
  end
end
