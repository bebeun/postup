class AddOriginToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :origin, :string
  end
end
