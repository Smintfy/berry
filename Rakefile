require 'rake'

desc "Build and install the gem"
task :install do
  sh "gem build berry.gemspec"
  gem_file = Dir["berry-*.gem"].sort.last
  sh "gem install #{gem_file}"
end
