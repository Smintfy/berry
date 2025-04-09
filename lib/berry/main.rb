require "berry/command"
require "berry/version"

module Berry
  def self.run(argv = ARGV)
    banner = "Usage: berry [options]"
  
    # Only parse specific global options, don't process the entire argv
    global_parser = OptionParser.new do |parser|
      parser.banner = banner
      parser.on("-v", "--version", "Show version") do
        puts "berry, version #{Berry::VERSION}"
        exit
      end
      parser.on("-h", "--help", "Show help message") do
        print_help_message
        exit
      end
    end
    
    # Extract only the recognized global options
    global_parser.order!(argv)

    if argv.empty?
      puts "Welcome to berry!"
      print_help_message
      return
    end

    command = COMMANDS[argv.shift]
    if command
      command.run(argv)
    else
      puts "Unknown command: #{command}"
      puts "See the list of available tasks with `berry -h`"
    end
  end

  def self.print_help_message
    puts <<~HELP
      Usage: berry <command> [options]

      Available commands:
        Directory and File utility
          make    <filepath>    [options]     Create a directory with optional description
          init    [options]                   Initialize a .berry directory within an existing directory
          edit    <filepath>    [options]     Edit a directory description
          ls      <filepath>                  List current directory contents
        
        Global options
          -h, --help                          Show help message
          -v, --version                       Show version
    HELP
  end

  COMMANDS = {
    "make"    => MakeCommand,
    "init"    => InitCommand,
    "edit"    => EditCommand,
    "ls"      => ListCommand,
    "version" => VersionCommand,
  }
end
