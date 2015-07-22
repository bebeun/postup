class AddSupportToCallActions < ActiveRecord::Migration
  def change
    add_column :call_actions, :support, :string, :default => "up"
  end
end
