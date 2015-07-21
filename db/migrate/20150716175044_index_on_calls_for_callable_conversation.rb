class IndexOnCallsForCallableConversation < ActiveRecord::Migration
  def change
	add_index :calls, [:callable_id,:callable_type,:conversation_id], :unique => true, :name => 'index_on_calls_for_callable_conversation'
  end
end
