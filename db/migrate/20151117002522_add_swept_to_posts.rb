class AddSweptToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :swept, :boolean, :default => false
  end
end
