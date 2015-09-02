class AddSupportableToUserActions < ActiveRecord::Migration
  def change
    add_reference :user_actions, :supportable, polymorphic: true, index: true
  end
end
