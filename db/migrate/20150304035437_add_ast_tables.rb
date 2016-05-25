class AddAstTables < ActiveRecord::Migration
  def change
    create_table :AST_trees do |t|
      t.references :session, index: true
      t.string :filename
      t.integer :git_tag
      t.timestamps
    end

    create_table :AST_tree_nodes do |t|
      t.references :AST_trees, index: true
      t.string :astType
      t.string :astLabel
      t.string :astTypeLabel
      t.integer :astPos
      t.string :astLength
      t.timestamps
    end

    create_table :AST_tree_relationships do |t|
      t.integer :parent_id
      t.integer :child_id
      t.timestamps
    end

  end
end


# # the people table
# create_table :people do |t|
#   t.column :name, :string
# end

# # the friendships association table
# create_table :friendships do |t|
#   t.column :person_id, :integer
#   t.column :friend_id, :integer
#   t.column :authorized, :boolean, :default => false
# end

# class Friendship < ActiveRecord::Base
#   # don't have to give class_name or foreign_key b/c ActiveRecord reflection works here
#   belongs_to :person

#   # make sure to give class_name and foreign_key b/c ActiveRecord doesn't know what friend is
#   belongs_to :friend, :class_name => "Person", :foreign_key => "friend_id"
# end

# class Person < ActiveRecord::Base
#   # tell ActiveRecord that a person has_many friendships or :through won't work
#   has_many :friendships

#   # create the has_many :through relationship
#   has_many :friends, :through => :friendships

#   # an example of how to get only the authorized friends
#   has_many :authorized_friends, :through => :friendships, :source => :friend, :conditions => [ "authorized = ?", true ]

#   # an example of how to get only the unauthorized friends
#   has_many :unauthorized_friends, :through => :friendships, :source => :friend, :conditions => [ "authorized = ?", false ]
# end
