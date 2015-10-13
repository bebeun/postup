class AddBrotherCallToAftfs < ActiveRecord::Migration
  def change
    add_reference :aftfs, :brother_call, index: true
    add_foreign_key :aftfs, :brother_calls
  end
end
