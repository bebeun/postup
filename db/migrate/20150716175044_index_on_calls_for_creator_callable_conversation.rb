class IndexOnCallsForCreatorCallableConversation < ActiveRecord::Migration
  def change
	add_index :calls, [:creator_id,:callable_id,:callable_type,:conversation_id], :unique => true, :name => 'index_on_calls_for_creator_callable_conversation'
  end
end
