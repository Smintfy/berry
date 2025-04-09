$:.push File.expand_path("../lib", __FILE__)

require "berry/version"

Gem::Specification.new do |s|
  s.name          = "berry"
  s.version       = Berry::VERSION
  s.authors       = ["Smintfy"]
  s.summary       = "Nothing to see here yet..."
  s.files         = Dir["lib/**/*.rb"] + ["bin/berry"]
  s.executables   = ["berry"]
  s.require_paths = ["lib"]
end