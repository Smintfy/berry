require 'fileutils'
require 'optparse'

module Berry
  def self.run(argv = ARGV)
    if argv.empty?
      print_welcome_message
      return
    end

    command = argv.shift
    case command
    when "make"
      MakeCommand.run(argv)
    when "edit"
      EditCommand.run(argv)
    when "ls"
      ListCommand.run(argv)
    else
      puts "Unknown command: #{command}"
      puts "See the list of available tasks with `berry -h`"
    end
  end

  class MakeCommand
    def self.run(argv)      
      options = {}
      opt_parser = OptionParser.new do |parser|
        parser.banner = "Usage: berry make <filename> [options]"

        parser.on("-dDESCRIPTION", "Add description to a folder") do |desc|
          options[:description] = desc
        end

        parser.on("-h", "--help", "Show make command help message") do
          puts parser
          exit
        end
      end

      begin
        opt_parser.parse!(argv)
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
        puts "Error: #{e.message}"
        puts opt_parser
        exit 1
      end

      filename = argv.shift
      unless filename
        puts "Error: You must provide a filename."
        puts opt_parser
        exit 1
      end

      Berry.create_directory(filename, "Successfully created directory named '#{filename}'")

      # Initialize a .berry directory if we specify the "-d" flag or option
      if options[:description]
        Dir.chdir(filename) do
          Berry.create_directory(".berry", "Initialized .berry folder")
          Dir.chdir(".berry") do
            File.write("description", options[:description])
          end
        end
      end
    end
  end

  class EditCommand
    def self.run(argv)
      options = {}
      opt_parser = OptionParser.new do |parser|
        parser.banner = "Usage: berry make <filename> [options]"

        parser.on("-dDESCRIPTION", "Add description to a folder") do |desc|
          options[:description] = desc
        end

        parser.on("-h", "--help", "Show make command help message") do
          puts parser
          exit
        end
      end

      begin
        opt_parser.parse!(argv)
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
        puts "Error: #{e.message}"
        puts opt_parser
        exit 1
      end
    end
  end

  class ListCommand
    def self.run(argv)
      opt_parser = OptionParser.new do |parser|
        parser.banner = "Usage: berry ls [options]"

        parser.on("-h", "--help", "Show make command help message") do
          puts parser
          exit
        end
      end

      begin
        opt_parser.parse!(argv)
      rescue OptionParser::InvalidOption => e
        puts "Error: #{e.message}"
        puts opt_parser
        exit 1
      end

      entries = Dir.children(".").reject { |entry| entry.start_with?(".") }
      max_entry_len = entries.map(&:length).max

      # Sort and group the entries based on if the entry is a directory or not.
      # In this case, the directory is first.
      sorted = entries.sort_by { |entry| File.directory?(entry) ? [1, entry] : [0, entry] }
                      .group_by { |entry| File.directory?(entry) ? :directory : :file  }
      
      # Display description if .berry directory exist within a directory
      sorted[:directory].each do |dir|
        berry_dir = File.join(dir, ".berry", "description")
        description = File.exist?(berry_dir) ? File.read(berry_dir) : nil

        if description
          padding = " " * max_entry_len
          puts "#{dir}#{padding}#{description}"
        else
          puts dir
        end
      end
      puts sorted[:file]
    end
  end

  def self.create_directory(path, success_message)
    if Dir.exist?(path)
      puts "Warning: Directory '#{path}' already exists."
    else
      FileUtils.mkdir_p(path)
      puts success_message
    end
  rescue StandardError => e
    raise RuntimeError, "Error: #{e.message}"
  end

  def self.print_welcome_message
    puts <<~HELP
      Welcome to berry!
      Usage: berry <command> [options]

      Available commands:
        make    <filename>    [-d <desc>]   Create a directory with optional description
        ls                                  List current directory contents
        -h, --help                          Show this help message
    HELP
  end
end
