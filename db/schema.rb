# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150306184347) do

  create_table "AST_diff_nodes", force: true do |t|
    t.integer  "AST_tree_nodes_id"
    t.integer  "AST_trees_id"
    t.string   "diffActionType"
    t.string   "diffObjectType"
    t.string   "diffObjectLabel"
    t.string   "diffParentType"
    t.integer  "diffBeforePos"
    t.integer  "diffBeforeLength"
    t.integer  "diffAfterPos"
    t.integer  "diffAfterLength"
    t.integer  "groupLeadNode"
    t.integer  "groupParentNode"
    t.integer  "groupNumber"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "AST_diff_nodes", ["AST_tree_nodes_id"], name: "index_AST_diff_nodes_on_AST_tree_nodes_id"
  add_index "AST_diff_nodes", ["AST_trees_id"], name: "index_AST_diff_nodes_on_AST_trees_id"

  create_table "AST_tree_nodes", force: true do |t|
    t.integer  "AST_trees_id"
    t.string   "astType"
    t.string   "astLabel"
    t.string   "astTypeLabel"
    t.integer  "astPos"
    t.string   "astLength"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "AST_tree_nodes", ["AST_trees_id"], name: "index_AST_tree_nodes_on_AST_trees_id"

  create_table "AST_tree_relationships", force: true do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "AST_trees", force: true do |t|
    t.integer  "session_id"
    t.string   "filename"
    t.integer  "git_tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "AST_trees", ["session_id"], name: "index_AST_trees_on_session_id"

  create_table "compiles", force: true do |t|
    t.integer  "phase_id"
    t.integer  "session_id"
    t.string   "light_color"
    t.integer  "git_tag"
    t.integer  "total_edited_line_count"
    t.integer  "production_edited_line_count"
    t.integer  "test_edited_line_count"
    t.integer  "total_test_method_count"
    t.integer  "total_test_run_count"
    t.integer  "total_test_run_fail_count"
    t.integer  "seconds_since_last_light"
    t.float    "statement_coverage"
    t.integer  "total_sloc_count"
    t.integer  "production_sloc_count"
    t.integer  "test_sloc_count"
    t.boolean  "test_change"
    t.boolean  "prod_change"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_method_count"
    t.integer  "total_assert_count"
    t.binary   "curr_AST_Tree",                limit: 1048576
    t.binary   "curr_AST_Diff",                limit: 1048576
  end

  add_index "compiles", ["phase_id"], name: "index_compiles_on_phase_id"
  add_index "compiles", ["session_id"], name: "index_compiles_on_session_id"

  create_table "cycles", force: true do |t|
    t.integer  "session_id"
    t.integer  "total_edit_count"
    t.integer  "production_edit_count"
    t.integer  "test_edit_count"
    t.integer  "total_sloc_count"
    t.integer  "production_sloc_count"
    t.integer  "test_sloc_count"
    t.float    "statement_coverage"
    t.integer  "cyclomatic_complexity"
    t.boolean  "valid_tdd"
    t.integer  "cycle_position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cycles", ["session_id"], name: "index_cycles_on_session_id"

  create_table "interrater_sessions", force: true do |t|
    t.integer  "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interrater_sessions", ["session_id"], name: "index_interrater_sessions_on_session_id"

  create_table "markup_assignments", force: true do |t|
    t.integer  "researcher_id"
    t.integer  "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "markup_assignments", ["researcher_id"], name: "index_markup_assignments_on_researcher_id"
  add_index "markup_assignments", ["session_id"], name: "index_markup_assignments_on_session_id"

  create_table "markups", force: true do |t|
    t.integer  "session_id"
    t.string   "user"
    t.string   "tdd_color"
    t.integer  "first_compile_in_phase"
    t.integer  "last_compile_in_phase"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "markups", ["session_id"], name: "index_markups_on_session_id"

  create_table "phases", force: true do |t|
    t.integer  "cycle_id"
    t.string   "tdd_color"
    t.integer  "seconds_in_phase"
    t.integer  "total_edit_count"
    t.integer  "production_edit_count"
    t.integer  "test_edit_count"
    t.integer  "total_sloc_count"
    t.integer  "production_sloc_count"
    t.integer  "test_sloc_count"
    t.integer  "total_line_change_count"
    t.integer  "production_line_change_count"
    t.integer  "test_line_change_count"
    t.integer  "first_compile_in_phase"
    t.integer  "last_compile_in_phase"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phases", ["cycle_id"], name: "index_phases_on_cycle_id"

  create_table "researchers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "kata_name"
    t.string   "cyberdojo_id"
    t.string   "language_framework"
    t.string   "path"
    t.string   "avatar"
    t.datetime "start_date"
    t.integer  "computed_time_secs"
    t.integer  "total_light_count"
    t.integer  "red_light_count"
    t.integer  "green_light_count"
    t.integer  "amber_light_count"
    t.integer  "max_consecutive_red_chain_length"
    t.integer  "total_sloc_count"
    t.integer  "production_sloc_count"
    t.integer  "test_sloc_count"
    t.integer  "total_edited_line_count"
    t.integer  "production_edited_line_count"
    t.integer  "test_edited_line_count"
    t.integer  "final_test_method_count"
    t.integer  "cumulative_test_run_count"
    t.integer  "cumulative_test_fail_count"
    t.integer  "final_cyclomatic_complexity"
    t.float    "final_branch_coverage"
    t.float    "final_statement_coverage"
    t.integer  "total_cycle_count"
    t.string   "final_light_color"
    t.float    "tdd_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "potential_complete"
    t.boolean  "is_complete"
    t.float    "test_cyclomatic_complexity"
    t.float    "production_cyclomatic_complexity"
    t.float    "final_production_file_method_count"
    t.float    "final_test_file_method_count"
    t.float    "final_total_method_count"
    t.float    "final_production_AST_node_count"
    t.float    "final_test_AST_node_count"
    t.float    "final_total_AST_node_count"
  end

end
