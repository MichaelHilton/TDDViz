require 'java'

require_relative 'OptParserLib.rb'		# Command-line options parsing library
require_relative 'JavaTestFinder.rb'	# JSON parser to evaluate test methods and assert invocations
require_relative 'gumtreeFacade.jar'	# Facade to a subset of the Java Gumtree AST parser library
require_relative 'gumtree.jar'			# Java Gumtree AST parser library (https://github.com/jrfaller/gumtree)

@ast = Java::gumtreeFacade.AST
# WARNING: the command-line options  for ASTInterface.rb require the following format:
#          jruby ASTInterface.rb --tree "/abs/path/to/file"
#          jruby ASTInterface.rb --diff "/abs/path/to/file1","/abs/path/to/file2"

def treeAST(source, extension)
  return @ast.getTreeAST(source, extension)
end

def treeAST(path)
  begin
    return @ast.getTreeAST(path)
  rescue java.lang.ArrayIndexOutOfBoundsException => e
    puts "ERROR FOUND!!"
    return "ERROR"
  rescue java.lang.NullPointerException => e
    puts "ERROR FOUND!!"
    return "ERROR"
  end
end

def diffAST(source, destination, extension)
  return @ast.getDiffAST(source, destination, extension)
end

def diffAST(src_path, dst_path)
  begin
    return @ast.getDiffAST(src_path, dst_path)
  rescue java.lang.ArrayIndexOutOfBoundsException => e
    puts "ERROR FOUND!!"
    return "ERROR"
  rescue java.lang.NullPointerException => e
    puts "ERROR FOUND!!"
    return "ERROR"
  end

end

def findChangeType(file_name,before_path,after_path)
  diffASTResult = diffAST(before_path + "/" + file_name, after_path + "/" + file_name)
  if diffASTResult.length == 3
    return "NO Change"
  else
    return findFileType(after_path + "/" + file_name)
  end

end

def findFileType(file_path)
  numAsserts = findAsserts(file_path)
  if numAsserts > 0
    return "Test"
  else
    return "Production"
  end

end

def findMethods(path)
  searcher = JavaTestFinder.new()

  file = File.open("temp.json", "w")
  file.puts treeAST(path)
  file.close
  abs_path = File.absolute_path(file)

  results = searcher.find_methods(abs_path)
  File.delete(file)

  return results
end

def findAllNodeCount(path)
  searcher = JavaTestFinder.new()

  file = File.open("temp.json", "w")
  file.puts treeAST(path)
  file.close
  abs_path = File.absolute_path(file)

  results = searcher.find_all_nodes(abs_path)
  File.delete(file)

  return results
end


def findAsserts(path)
  searcher = JavaTestFinder.new()
  results = []
  file = File.open("temp.json", "w")
  treeString = treeAST(path)
  if treeString == "ERROR"
    return 0
  end
  file.puts treeString
  file.close
  abs_path = File.absolute_path(file)

  results = searcher.find_tests(abs_path)
  File.delete(file)
  return results["allAsserts"]
end

# Optional command-line execution using --tree or --diff options
options = Optparser.parse(ARGV)

if options.tree
  fname = options.files.fetch(0, "No filepath argument")
  unless File.exist?(fname)
    puts "File not located on path " + File.absolute_path(__FILE__)
  else
    puts treeAST(File.path(fname))
  end
end

if options.diff
  fname1 = options.files.fetch(0, "No filepath argument")
  fname2 = options.files.fetch(1, "No filepath argument")
  unless File.exist?(fname1) || File.exist?(fname2)
    puts "Files not located on path " + File.absolute_path(__FILE__)
  else
    puts diffAST(File.path(fname1), File.path(fname2))
  end
end
