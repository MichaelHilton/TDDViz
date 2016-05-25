class AstTree < ActiveRecord::Base
  #   # tell ActiveRecord that a person has_many friendships or :through won't work
  has_many :ast_tree_nodes
  belongs_to :session

  # def self.getMyID
  #   return "ID"
  # end

  def fullJSONTree(id)
    puts "@@@@@@@@@@@@@@@@@@@@@  fullJSONTree @@@@@@@@@@@@@@@@@@@@@"




    puts "id: "
    puts id
    tree = AstTree.find_by(id: id)
    puts tree
    rootNode = AstTreeNode.find_by(AST_Trees_id: tree.id, astPos: 0)
    puts rootNode.inspect

    @allDiffs = AstDiffNode.where(AST_Trees_id: tree.id)
    puts "All Diffs " + @allDiffs.inspect
    tree_JSON = buildASTNode(rootNode.id)


    puts JSON.generate(tree_JSON)


    puts "@@@@@@@@@@@@@@@@@@@@@  END @@@@@@@@@@@@@@@@@@@@@"
    # return JSON.generate(tree_JSON)
    return tree_JSON
  end

  def buildASTNode(id)


    puts "BUILD AST NODE"
    curr_node =  AstTreeNode.find_by(id: id)
    tree_JSON = Hash.new


    # if @allDiffs.any? {|diff| diff.diffBeforePos == curr_node.astPos}
    #   puts "match"
    #   puts diff.inspect
    #   tree_JSON[:diffStatus] = diff.diffActionType
    # end

    @allDiffs.each do |diff|

      if diff.diffActionType == "Insert"
        if diff.diffBeforePos == curr_node.astPos
          # puts "Match"
          tree_JSON[:diffStatus] = diff.diffActionType
          break
        end
      elsif diff.diffActionType == "Move" || diff.diffActionType == "Update"
        if diff.diffAfterPos == curr_node.astPos
          # puts "Match"
          tree_JSON[:diffStatus] = diff.diffActionType
          break
        end

        # elsif diff.diffActionType == "Delete"



      end


    end





    tree_JSON[:type] = curr_node.astType
    tree_JSON[:label] = curr_node.astLabel
    tree_JSON[:typeLabel] = curr_node.astTypeLabel
    tree_JSON[:pos] = curr_node.astPos
    tree_JSON[:length] = curr_node.astLength

    childrenArray = Array.new
    # allChildren = AstTreeRelationships.where(parent_id: id)
    AstTreeRelationships.where(parent_id: id).each do |child|
      puts "&&&&&&&&&&&&&& CHILD &&&&&&&&&&&&&& "
      puts child.inspect
      childrenArray.push(buildASTNode(child.child_id))
    end
    tree_JSON[:children] = childrenArray
    return tree_JSON
  end



end
