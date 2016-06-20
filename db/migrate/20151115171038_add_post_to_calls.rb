class AddPostToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :post, index: true
    add_foreign_key :calls, :posts
  end
end
