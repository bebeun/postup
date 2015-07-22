class AddCategoryToProfiles < ActiveRecord::Migration
  def change
    add_reference :profiles, :category, index: true
    add_foreign_key :profiles, :categories
  end
end
