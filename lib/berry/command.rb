require 'optparse'

require "berry/utils"

module Berry
  class MakeCommand
    def self.run(argv)      
      banner = "Usage: berry make <filepath> [options]"
      options = Berry::BaseCommand.parse(argv, banner) do |parser, options|
        parser.on("-d <description>", "Add description to a directory") do |desc|
          options[:description] = desc
        end
      end

      filepath = argv.shift
      unless filepath
        puts "Error: You must provide a filepath."
        puts banner
        exit 1
      end

      Berry::Utils.create_directory(filepath, "Successfully created directory named '#{filepath}'")

      # Initialize a .berry directory if we specify the "-d" flag or option
      if options[:description]
        Dir.chdir(filepath) do
          Berry::Utils.create_directory(".berry", "Initialized .berry directory")
          Dir.chdir(".berry") do
            File.write("description", options[:description])
          end
        end
      end
    end
  end

  class InitCommand
    def self.run(argv)
      banner = "Usage: berry init [options]"
      options = Berry::BaseCommand.parse(argv, banner) do |parser, options|
        parser.on("-dDESCRIPTION", "Add description to a directory") do |desc|
          options[:description] = desc
        end
      end

      base_path = argv.shift || "."
      berry_path = File.join(base_path, ".berry")

      # Initialize a .berry directory if it doesn't exist
      unless Dir.exist?(berry_path)
        Berry::Utils.create_directory(berry_path, "Successfully initialized a .berry directory in #{base_path}")
        if options[:description]
            Dir.chdir(".berry") do
              File.write("description", options[:description])
            end
        end
      else
        puts "Warning: .berry directory already exist."
      end
    end
  end

  class EditCommand
    def self.run(argv)
      banner = "Usage: berry edit <filepath> [options]"
      options = Berry::BaseCommand.parse(argv, banner) do |parser, options|
        parser.on("-dDESCRIPTION", "Add description to a directory") do |desc|
          options[:description] = desc
        end
      end

      base_path = argv.shift || "."

      unless options[:description]
        puts "Error: You must provide a new description with -d."
        puts banner
        exit 1
      end

      unless Dir.exist?(base_path)
        puts "Error: Directory '#{base_path}' does not exist."
        exit 1
      end

      berry_path = File.join(base_path, ".berry")
      unless Dir.exist?(berry_path)
        puts "Error: This directory is not initialized. Run `berry init` first."
        exit 1
      end

      File.write(File.join(berry_path, "description"), options[:description])
      puts "Updated description for '#{base_path}'"
    end
  end

  class ListCommand
    def self.run(argv)
      # TODO: options
      banner = "Usage: berry ls <filepath>"
      Berry::BaseCommand.parse(argv, banner)

      base_path = argv.shift || "."
      entries = Dir.children(base_path).reject { |entry| entry.start_with?(".") } # We ignore dot directory for now

      # Sort and group the entries based on if the entry is a directory or not.
      directories = []
      files = []
      entries.each do |entry|
        full_path = File.join(base_path, entry)
        if File.directory?(full_path)
          directories << entry
        else
          files << entry
        end
      end

      # In this case, the directory is first.
      sorted = {
        directory: directories.sort,
        file: files.sort
      }
      
      # Display description if .berry directory exist within a directory
      sorted.fetch(:directory, []).each do |dir|
        puts dir

        full_path = File.join(base_path, dir)
        berry_path = File.join(full_path, ".berry", "description")
        
        next unless File.exist?(berry_path)
        
        description = File.read(berry_path).strip
        puts "  ↳ #{description}" unless description.empty? # Prints non-empty description or should we have an indicator for empty description?
      end
      puts sorted[:file] if sorted[:file]&.any?
    end
  end

  class VersionCommand
    def self.run(argv)
      banner = "Usage: berry version"
      Berry::BaseCommand.parse(argv, banner)
      puts "berry, version #{Berry::VERSION}"
    end
  end

  class BaseCommand
    def self.parse(argv, banner)
      options = {}

      opt_parser = OptionParser.new do |parser|
        parser.banner = banner
        parser.on("-h", "--help", "Show help message") do
          puts parser
          exit
        end
        yield(parser, options) if block_given? # The block for all the other options
      end

      begin
        opt_parser.parse!(argv)
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
        puts "Error: #{e.message}"
        puts opt_parser
        exit 1
      end

      options
    end
  end
end