class AddActivatedToFacebookActivations < ActiveRecord::Migration
  def change
    add_column :facebook_activations, :activated, :boolean, default: false
  end
end
