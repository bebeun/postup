class AddCreatorToConversations < ActiveRecord::Migration
  def change
    add_reference :conversations, :creator, index: true
    #add_foreign_key :conversations, :creators
  end
end
