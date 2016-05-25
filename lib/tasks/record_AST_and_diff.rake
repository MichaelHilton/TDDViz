task :record_AST_and_diff do
  record_AST_and_diff
end

# This data can be loaded with the rake db:seed (or created alongside the db with db:setup).
root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'
require_relative root + '/lib/ASTInterface/ASTInterface'


def root_path
  Rails.root.to_s + '/'
end

def store_AST_Tree(session_id,curr_path,filename,git_tag)
  # puts "store_AST_Tree"
  ast_tree_string = treeAST(curr_path + "/" + filename)
  # puts ast_tree_string
  ast_tree = AstTree.new
  ast_tree.filename = filename
  ast_tree.git_tag = git_tag
  ast_tree.session_id = session_id
  ast_tree.save

  json_ast_string = JSON.parse(ast_tree_string)
  # puts ast_tree_string
  # puts json_ast_string["type"]
  # puts json_ast_string["typeLabel"]
  # puts json_ast_string["pos"]
  # puts json_ast_string["length"]
  # puts json_ast_string["children"][0]["type"]
  # puts json_ast_string["children"].length


  currAstTreeNode = AstTreeNode.new
  currAstTreeNode.astType = json_ast_string["type"]
  currAstTreeNode.astTypeLabel = json_ast_string["typeLabel"]
  currAstTreeNode.astPos = json_ast_string["pos"]
  currAstTreeNode.astLabel = json_ast_string["label"]
  currAstTreeNode.astLength = json_ast_string["length"]
  currAstTreeNode.AST_trees_id = ast_tree.id
  currAstTreeNode.save

  saveChildrenToDB(json_ast_string["children"],currAstTreeNode,ast_tree)
end


def saveChildrenToDB(childrenArray,parent,astTree)
  # puts "========== CHILD =========="
  # puts childrenArray.inspect
  # puts childrenArray
  childrenArray.each do |child|
    # puts "========== CHILD =========="
    currAstTreeNode = AstTreeNode.new
    currAstTreeNode.astType = child["type"]
    currAstTreeNode.astTypeLabel = child["typeLabel"]
    currAstTreeNode.astLabel = child["label"]
    currAstTreeNode.astPos = child["pos"]
    currAstTreeNode.astLength = child["length"]
    currAstTreeNode.AST_trees_id = astTree.id
    currAstTreeNode.save

    astTreeRel = AstTreeRelationships.new
    astTreeRel.parent_id = parent.id
    astTreeRel.child_id = currAstTreeNode.id
    astTreeRel.save
    # puts child.inspect

    saveChildrenToDB(child["children"],currAstTreeNode,astTree)
  end
end


def saveASTChanges(ast_JSON_string,session_id,git_tag,filename)
  # puts "================ saveASTChanges ================"
  # puts "ast_JSON_string: "+ ast_JSON_string
  json_diff_nodes = JSON.parse(ast_JSON_string)
  json_diff_nodes.each do |ast_diff_node|

    # puts "^^^^^^^^^^^^^^^^^^^^ AST DIFF NODE ^^^^^^^^^^^^^^^^^^^^"
    # puts ast_diff_node.inspect
    currASTDiffNode = AstDiffNode.new
    currASTDiffNode.diffActionType = ast_diff_node["action_type"]
    currASTDiffNode.diffObjectType = ast_diff_node["object"]["type"]
    currASTDiffNode.diffObjectLabel = ast_diff_node["object"]["label"]
    currASTDiffNode.diffBeforePos = ast_diff_node["before"]["pos"]
    currASTDiffNode.diffBeforeLength = ast_diff_node["before"]["length"]
    if ast_diff_node["after"]
      currASTDiffNode.diffAfterPos = ast_diff_node["after"]["pos"]
      currASTDiffNode.diffAfterLength = ast_diff_node["after"]["length"]
    end
    print "Session_id: " + session_id.to_s
    print " git_tag:"+ git_tag.to_s
    puts " filename:" + filename.to_s
    currASTTree = AstTree.find_by(session_id: session_id,git_tag: git_tag, filename: filename)
    # puts currASTTree.inspect
    currASTDiffNode.AST_trees_id = currASTTree.id
    currASTDiffNode.save
  end
end



def record_AST_and_diff
  FileUtils.mkdir_p BUILD_DIR, :mode => 0700
  AstTree.delete_all
  AstTreeNode.delete_all
  AstTreeRelationships.delete_all
  AstDiffNode.delete_all

  Session.find_by_sql("SELECT * from Sessions where tdd_score > .7 AND total_cycle_count > 3").each do |session|

    puts "~~~~~~~~~~~~~~~~~~~~~~~~ Session "+session.id.to_s+" ~~~~~~~~~~~~~~~~~~~~~~~~"
    # @currSession = session
    # puts session.inspect
    session.compiles.each_with_index do |compile, index|
      # puts "compile.git_tag: "+ compile.git_tag.to_s
      puts "index: "+ index.to_s

      path = "#{BUILD_DIR}/" + compile.git_tag.to_s + "/src"

      curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[compile.git_tag-1])
      curr_files = curr_files.select{ |filename| filename.include? ".java" }
      curr_filenames = curr_files.map{ |file| File.basename(file) }

      curr_filenames.each do |filename|
        # prev_path = "#{BUILD_DIR}/" + prev.git_tag.to_s + "/src"
        curr_path = "#{BUILD_DIR}/" + compile.git_tag.to_s + "/src"
        # puts "File To Match" + filename

        store_AST_Tree(session.id,curr_path,filename,compile.git_tag)
      end
    end

    session.compiles.each_cons(2) do |prev, curr|
      puts "prev: " + prev.git_tag.to_s + " -> curr: " + curr.git_tag.to_s

      prev_files = Dir.entries("#{BUILD_DIR}/" + prev.git_tag.to_s + "/src")
      curr_files = Dir.entries("#{BUILD_DIR}/" + curr.git_tag.to_s + "/src")

      prev_files = prev_files.select{ |filename| filename.include? ".java" }
      curr_files = curr_files.select{ |filename| filename.include? ".java" }

      prev_filenames = prev_files.map{ |file| File.basename(file) }
      curr_filenames = curr_files.map{ |file| File.basename(file) }

      # puts "prev_filenames: "+ prev_filenames.inspect
      # puts "curr_filenames: "+ curr_filenames.inspect


      curr_filenames.each do |filename|
        prev_path = "#{BUILD_DIR}/" + prev.git_tag.to_s + "/src"
        curr_path = "#{BUILD_DIR}/" + curr.git_tag.to_s + "/src"

        # puts "File To Match: " + filename
        # puts "prev_path: " + prev_path
        # puts "curr_path: " + curr_path

        if prev_filenames.include?(filename)
          # puts "FOUND CHANGES FOR "+filename
          astDiffJSONArray = diffAST(prev_path + "/" + filename,curr_path + "/" + filename)
          saveASTChanges(astDiffJSONArray,session.id,curr.git_tag,filename)
        end
      end
    end
    FileUtils.remove_entry_secure(BUILD_DIR)
  end

end
