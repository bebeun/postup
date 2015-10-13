class AddParentToAftfs < ActiveRecord::Migration
  def change
    add_reference :aftfs, :parent, polymorphic: true, index: true
  end
end
