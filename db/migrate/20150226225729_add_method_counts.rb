class AddMethodCounts < ActiveRecord::Migration
  def change
  	add_column :sessions, :final_production_file_method_count, :float
  	add_column :sessions, :final_test_file_method_count, :float
    add_column :sessions, :final_total_method_count, :float
  end
end
