class AddDeciderCallToAftfs < ActiveRecord::Migration
  def change
    add_reference :aftfs, :decider_call, index: true
    add_foreign_key :aftfs, :decider_calls
  end
end
