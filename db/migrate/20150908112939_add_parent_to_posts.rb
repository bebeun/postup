class AddParentToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :parent, polymorphic: true, index: true
  end
end
