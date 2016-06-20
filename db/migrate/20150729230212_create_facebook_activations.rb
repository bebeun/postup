class CreateFacebookActivations < ActiveRecord::Migration
  def change
    create_table :facebook_activations do |t|
      t.references :user, index: true
      t.references :facebook, index: true
      t.string :token

      t.timestamps null: false
    end
    add_foreign_key :facebook_activations, :users
    add_foreign_key :facebook_activations, :facebooks
  end
end
