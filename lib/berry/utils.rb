require "fileutils"

module Berry
  class Utils
    def self.create_directory(path, success_message)
      begin
        if Dir.exist?(path)
          puts "Warning: Directory '#{path}' already exists."
        else
          FileUtils.mkdir_p(path)
          puts success_message
        end
      rescue StandardError => e
        raise RuntimeError, "Error: #{e.message}"
      end
    end
  end
end