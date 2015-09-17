class AddParentCallToAftfs < ActiveRecord::Migration
  def change
    add_reference :aftfs, :parent_call, polymorphic: true, index: true
  end
end
