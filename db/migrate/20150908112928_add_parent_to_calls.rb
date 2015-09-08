class AddParentToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :parent, polymorphic: true, index: true
  end
end
