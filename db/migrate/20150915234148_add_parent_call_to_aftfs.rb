class AddParentCallToAftfs < ActiveRecord::Migration
  def change
    add_reference :aftfs, :parent_call, index: true
    add_foreign_key :aftfs, :parent_calls
  end
end
