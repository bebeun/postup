class AddIdentableToProfiles < ActiveRecord::Migration
  def change
    add_reference :profiles, :identable, polymorphic: true, index: true
  end
end
