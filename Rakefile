require "rubygems"
require "rake"
require "rake/clean"
require "rdoc/task"

task :default => ["build"]
CLEAN.include [ 'pkg', 'doc' ]
name = "rudy"
key = File.join('/mnt/gem/', 'gem-private_key.pem');

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require "rudy"
version = Rudy::VERSION.to_s

begin
  require "jeweler"
  Jeweler::Tasks.new do |s|
    s.version = version
    s.name = name
    s.rubyforge_project = s.name
    s.summary = "Rudy: a modern scripting tool for building, deploying, and maintaining."
    s.description = s.summary
    s.email = "rudy@solutious.com"
    s.homepage = "https://github.com/delano/rudy"
    s.authors = ["Delano Mandelbaum"]

    s.add_development_dependency 'tryouts'

    s.license = "MIT"

    if File.exists?(key)
      s.cert_chain  = ['gem-public_cert.pem']
      s.signing_key = key
    end
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs = ["lib", "test"]
end

extra_files = %w[LICENSE.txt ]
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "#{name} #{version}"
  rdoc.generator = 'hanna' # gem install hanna-nouveau
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("bin/*.rb")
  rdoc.rdoc_files.include("lib/**/*.rb")
  extra_files.each { |file|
    rdoc.rdoc_files.include(file) if File.exists?(file)
  }
end
