class AddCallableToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :callable, polymorphic: true, index: true
    #add_foreign_key :calls, :callable
  end
end
