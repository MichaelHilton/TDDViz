class AstDiffNode < ActiveRecord::Base
  # don't have to give class_name or foreign_key b/c ActiveRecord reflection works here
  # belongs_to :AST_tree_node

  # make sure to give class_name and foreign_key b/c ActiveRecord doesn't know what friend is
  # belongs_to :AST_child, :class_name => "Person", :foreign_key => "friend_id"
end
