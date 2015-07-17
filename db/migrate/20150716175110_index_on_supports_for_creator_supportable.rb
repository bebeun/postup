class IndexOnSupportsForCreatorSupportable < ActiveRecord::Migration
  def change
	add_index :supports, [:creator_id,:supportable_id,:supportable_type], :unique => true, :name => 'index_on_supports_for_creator_supportable'
  end
end
