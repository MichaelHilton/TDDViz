class AddFinalAstNodeCounts < ActiveRecord::Migration
  def change
    add_column :sessions, :final_production_AST_node_count, :float
    add_column :sessions, :final_test_AST_node_count, :float
    add_column :sessions, :final_total_AST_node_count, :float
  end
end
