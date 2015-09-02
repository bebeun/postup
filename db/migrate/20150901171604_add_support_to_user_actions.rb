class AddSupportToUserActions < ActiveRecord::Migration
  def change
    add_column :user_actions, :support, :string
  end
end
