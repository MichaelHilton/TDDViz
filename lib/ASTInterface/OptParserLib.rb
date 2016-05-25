require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

class Optparser

  # Return a structure describing the options.
  def self.parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.tree = false
    options.diff = false
    options.xtra = false
    options.files = []
    options.encoding = "utf8"

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: ASTInterface.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      # Mandatory argument.
      opts.on("-t", "--tree FILE", "Requires the file path before executing gumtree AST tree generation") do |file|
      	options.tree = true
        options.files << file
      end

      opts.on("-d", "--diff SRC,DST", Array, "Requires both src and dst file paths before executing gumtree AST diff generation") do |files|
      	options.diff = true
        files.each do |file|
          options.files << file
        end
      end

      opts.separator ""
      opts.separator "Common options:"

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

    end

    opts.parse!(args)
    options
  end  # parse()

end  # class Optparser