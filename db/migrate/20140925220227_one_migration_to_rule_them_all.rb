class OneMigrationToRuleThemAll < ActiveRecord::Migration
  def change

    create_table :markups do |t|
      t.references :session, index: true
      t.string :user
      t.string :tdd_color
      t.integer :first_compile_in_phase
      t.integer :last_compile_in_phase
      t.string :cyberdojo_id
      t.string :avatar

      t.timestamps
    end

    create_table :compiles do |t|
      t.references :phase, index: true
      t.references :session, index: true
      t.string :light_color
      t.integer :git_tag
      t.integer :total_edited_line_count
      t.integer :production_edited_line_count
      t.integer :test_edited_line_count
      t.integer :total_test_method_count
      t.integer :total_test_run_count
      t.integer :total_test_run_fail_count
      t.integer :seconds_since_last_light
      t.float :statement_coverage
      t.integer :total_sloc_count
      t.integer :production_sloc_count
      t.integer :test_sloc_count
      t.boolean :test_change
      t.boolean :prod_change

      t.timestamps
    end

    create_table :phases do |t|
      t.references :cycle, index: true
      t.string :tdd_color
      t.integer :seconds_in_phase
      t.integer :total_edit_count
      t.integer :production_edit_count
      t.integer :test_edit_count
      t.integer :total_sloc_count
      t.integer :production_sloc_count
      t.integer :test_sloc_count
      t.integer :total_line_change_count
      t.integer :production_line_change_count
      t.integer :test_line_change_count
      t.integer :first_compile_in_phase
      t.integer :last_compile_in_phase

      t.timestamps
    end

    create_table :cycles do |t|
      t.references :session, index: true
      t.integer :total_edit_count
      t.integer :production_edit_count
      t.integer :test_edit_count
      t.integer :total_sloc_count
      t.integer :production_sloc_count
      t.integer :test_sloc_count
      t.float :statement_coverage
      t.integer :cyclomatic_complexity
      t.boolean :valid_tdd
      t.integer :cycle_position

      t.timestamps
    end

    create_table :sessions do |t|
      t.string :kata_name
      t.string :cyberdojo_id
      t.string :language_framework
      t.string :path
      t.string :avatar
      t.datetime :start_date
      t.integer :computed_time_secs
      t.integer :total_light_count
      t.integer :red_light_count
      t.integer :green_light_count
      t.integer :amber_light_count
      t.integer :max_consecutive_red_chain_length
      t.integer :total_sloc_count
      t.integer :production_sloc_count
      t.integer :test_sloc_count
      t.integer :total_edited_line_count
      t.integer :production_edited_line_count
      t.integer :test_edited_line_count
      t.integer :final_test_method_count
      t.integer :cumulative_test_run_count
      t.integer :cumulative_test_fail_count
      t.integer :final_cyclomatic_complexity
      t.float :final_branch_coverage
      t.float :final_statement_coverage
      t.integer :total_cycle_count
      t.string :final_light_color
      t.float :tdd_score

      t.timestamps
    end
  end
end
