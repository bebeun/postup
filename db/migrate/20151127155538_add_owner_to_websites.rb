class AddOwnerToWebsites < ActiveRecord::Migration
  def change
    add_reference :websites, :owner, polymorphic: true, index: true
  end
end
