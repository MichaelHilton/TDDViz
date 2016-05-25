class AddAstDiffs < ActiveRecord::Migration
  def change

    create_table :AST_diff_nodes do |t|
      t.references :AST_tree_nodes, index: true
      t.references :AST_trees, index: true
      t.string :diffActionType
      t.string :diffObjectType
      t.string :diffObjectLabel
      t.string :diffParentType
      t.integer :diffBeforePos
      t.integer :diffBeforeLength
      t.integer :diffAfterPos
      t.integer :diffAfterLength
      t.integer :groupLeadNode
      t.integer :groupParentNode
      t.integer :groupNumber
      t.timestamps
    end

  end
end
