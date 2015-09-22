class AddAnswerCallToAftfs < ActiveRecord::Migration
  def change
    add_reference :aftfs, :answer_call, polymorphic: true, index: true
  end
end
