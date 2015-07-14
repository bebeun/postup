class AddSupportableToSupports < ActiveRecord::Migration
  def change
    add_reference :supports, :supportable, polymorphic: true, index: true
    add_foreign_key :supports, :supportables
  end
end
