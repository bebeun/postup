class AddProfileableToProfiles < ActiveRecord::Migration
  def change
    add_reference :profiles, :profileable, polymorphic: true, index: true
  end
end
