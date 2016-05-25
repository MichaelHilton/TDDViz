class AddAstTreeandDiff < ActiveRecord::Migration
  def change
    add_column :compiles, :curr_AST_Tree, :binary, :limit => 1.megabyte
    add_column :compiles, :curr_AST_Diff, :binary, :limit => 1.megabyte
  end
end
