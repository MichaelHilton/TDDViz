class AstTreeNode < ActiveRecord::Base
  belongs_to :ast_tree
  #   # tell ActiveRecord that a person has_many friendships or :through won't work
  has_many :AST_tree_relationships

  #   # create the has_many :through relationship
  # has_many :children, :through => :AST_tree_relationships

  #   # an example of how to get only the authorized friends
  #   has_many :authorized_friends, :through => :friendships, :source => :friend, :conditions => [ "authorized = ?", true ]

  #   # an example of how to get only the unauthorized friends
  #   has_many :unauthorized_friends, :through => :friendships, :source => :friend, :conditions => [ "authorized = ?", false ]

end
