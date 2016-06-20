class AddReportedToFacebookActivations < ActiveRecord::Migration
  def change
    add_column :facebook_activations, :reported, :boolean, default: false
  end
end
