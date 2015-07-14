class AddCreatorToSupports < ActiveRecord::Migration
  def change
    add_reference :supports, :creator, index: true
    add_foreign_key :supports, :creators
  end
end
