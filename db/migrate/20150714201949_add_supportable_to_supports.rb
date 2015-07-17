class AddSupportableToSupports < ActiveRecord::Migration
  def change
    add_reference :supports, :supportable, polymorphic: true, index: true
    add_foreign_key :supports, :supportables
	#add_index :supports, [:creator_id,:supportable_id,:supportable_type], :unique => true, :name => 'index_on_supports_for_creator_supportable'
  end
end
