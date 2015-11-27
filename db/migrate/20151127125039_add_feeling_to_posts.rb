class AddFeelingToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :feeling, :string, :default => "neutral"
  end
end
