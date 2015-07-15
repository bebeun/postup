class AddIndexCreatorTargetConversationToCallouts < ActiveRecord::Migration
	def change
		add_index :callouts, [:creator_id, :target_id, :conversation_id], :unique => true
	end
end
