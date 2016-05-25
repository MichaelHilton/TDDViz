# JSON Parsing example
require "rubygems"
require "json"

class JavaTestFinder

  def find_methods(filePath)
    json = get_json_from_file(filePath)

    #find all methods
    found_methods = []
    find_nodes(json, found_methods, ->(x){is_method(x)})

    found_methods.length
  end    

  def find_tests(filePath)
    json = get_json_from_file(filePath)

    #find all methods
    found_methods = []
    find_nodes(json, found_methods, ->(x){is_method(x)})

    #find all test methods
    test_methods = found_methods.find_all{|method| is_test(method)}

    #for each test method, get its asserts
    test_assert_map = find_direct_asserts(test_methods)

    #get all asserts
    all_asserts = find_asserts(json)

    format_output(test_assert_map, all_asserts)
  end

  def format_output(test_assert_map, all_asserts)
  	result = {}

    result["tests"] = test_assert_map.keys.size

    if test_assert_map.keys.size > 0
    	result["directAsserts"] = test_assert_map.values.reduce(:+) 
    else
    	result["directAsserts"] = 0
    end

    result["allAsserts"] = all_asserts.size

    result
  end

  def find_direct_asserts(tests)
  	test_assert_map = {}
    
    tests.each do |test|
    	test_assert_map[get_method_name(test)] = 0
    end

  	tests.each do |test|
  		asserts = find_asserts(test)
  		test_assert_map[get_method_name(test)] = asserts.size
  	end

  	test_assert_map
  end

  def find_asserts(node)
  	#find all method invocations
  	method_invocations = []
  	find_nodes(node, method_invocations, ->(x){is_method_invocation(x)})

  	#retain invocations that start with "assert"
  	asserts = method_invocations.find_all{|invocation| is_assert(invocation)}

  	asserts
  end

  def is_assert(invocation)
  	valid_assert_names = ["assertArrayEquals", "assertEquals", "assertNotSame", "assertNull", "assertSame", "assertThat", "assertTrue", "assertFalse"]
  	method_name = get_method_name(invocation)

  	is_valid = valid_assert_names.include? method_name

  	puts "method #{method_name} not recognized as valid assert" if !is_valid && (method_name.include? "assert")

  	is_valid
  end

  def get_json_from_file(filePath)
    file = open(filePath)
    content = file.read

    return JSON.parse(content)
  end

  def is_test(method)
    annotation = find_direct_child(method, ->(x){is_annotation(x)})

    return false if annotation.nil?

    is_test_annotation(annotation) ? true : false
  end

  def is_test_annotation(annotation)
    annotationString = find_direct_child(annotation, ->(x){is_qualified_name(x)})
    
    if annotationString.nil?
      annotationString = find_direct_child(annotation, ->(x){is_simple_name(x)})
    end

    return false if annotationString.nil?

    annotationString["label"].include? "Test"
  end

  def is_method(node)
    node["typeLabel"] == "MethodDeclaration"
  end

  def is_annotation(node)
    node["typeLabel"] == "MarkerAnnotation"
  end

  def is_qualified_name(node)
    node["typeLabel"] == "QualifiedName"
  end

  def is_method_invocation(node)
  	node["typeLabel"] == "MethodInvocation"
  end

  def is_simple_name(node)
  	node["typeLabel"] == "SimpleName"
  end

  def find_direct_child(node, childOKLambda)
    node["children"].find{|child| childOKLambda.call(child)}
  end

  def find_nodes(root, found_nodes, propertyLambda)

    if propertyLambda.call(root)
    	found_nodes << root
    end

    root["children"].each do |child|
      find_nodes(child, found_nodes, propertyLambda)
    end
  end

 #works for both method declarations and method invocations
 def get_method_name(method)
  	simple_name = find_direct_child(method, ->(child){is_simple_name(child)})
  	simple_name["label"]
  end
end
