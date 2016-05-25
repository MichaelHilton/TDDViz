class AddPartialCc < ActiveRecord::Migration
  def change
    add_column :sessions, :test_cyclomatic_complexity, :float
    add_column :sessions, :production_cyclomatic_complexity, :float
  end
end
