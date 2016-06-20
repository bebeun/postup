class AddMailnumberToFacebookActivations < ActiveRecord::Migration
  def change
    add_column :facebook_activations, :mailnumber, :integer, default: 0
  end
end
