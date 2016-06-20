class AddOwnerToFacebooks < ActiveRecord::Migration
  def change
    add_reference :facebooks, :owner, polymorphic: true, index: true
  end
end
