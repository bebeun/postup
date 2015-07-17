class IndexOnCalloutsForCreatorCalloutableConversation < ActiveRecord::Migration
  def change
	add_index :callouts, [:creator_id,:calloutable_id,:calloutable_type,:conversation_id], :unique => true, :name => 'index_on_callouts_for_creator_calloutable_conversation'
  end
end
