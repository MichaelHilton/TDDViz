class AddDetailsToCompiles < ActiveRecord::Migration
  def change
    add_column :compiles, :total_method_count, :integer
    add_column :compiles, :total_assert_count, :integer
  end
end
