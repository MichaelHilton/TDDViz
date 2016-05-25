class AddMaybeCompleteToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :potential_complete, :boolean
    add_column :sessions, :is_complete, :boolean
  end
end
