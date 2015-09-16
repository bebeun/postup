class AddSupportToAftfActions < ActiveRecord::Migration
  def change
    add_column :aftf_actions, :support, :string
  end
end
