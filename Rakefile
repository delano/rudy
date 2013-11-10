require "rubygems"
require "rake"
require "rake/clean"
require "rdoc/task"

task :default => ["build"]
CLEAN.include [ "pkg", "doc" ]
name = "rudy"
key = "/etc/certs/gem-private_key.pem";

$:.unshift File.join(File.dirname(__FILE__), "lib")
require "rudy"
version = Rudy::VERSION.to_s

begin
  require "jeweler"
  Jeweler::Tasks.new do |s|
    s.version = version
    s.name = name
    s.rubyforge_project = s.name
    s.summary = "Rudy: a modern scripting tool for building, deploying, and maintaining projects and servers."
    s.description = s.summary + " "
    s.email = "rudy@solutious.com"
    s.homepage = "https://github.com/delano/rudy"
    s.authors = ["Delano Mandelbaum"]

    s.required_ruby_version  = '>= 1.9.3'

    s.add_dependency 'addressable', '~> 2.2'
    s.add_dependency 'yajl-ruby',   '~> 1.1'
    s.add_dependency 'httparty',    '~> 0.12'
    s.add_dependency 'mustache',    '~> 0.99'

    s.add_dependency 'redis',       '~> 2.2'
    s.add_dependency 'redis-dump',  '~> 0.3'

    s.add_dependency 'sysinfo',     '~> 0.7'
    s.add_dependency 'annoy',       '~> 0.5'
    s.add_dependency 'rye',         '~> 0.9'
    s.add_dependency 'gibbler',     '~> 0.8'
    s.add_dependency 'drydock',     '~> 0.6'

    s.add_development_dependency "tryouts"

    s.license = "MIT"

    if File.exists?(key)
      s.cert_chain  = ["gem-public_cert.pem"]
      s.signing_key = key
    end
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs = ["lib", "test"]
end

extra_files = %w[LICENSE.txt ]
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "#{name} #{version}"
  rdoc.generator = "hanna" # gem install hanna-nouveau
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("bin/*.rb")
  rdoc.rdoc_files.include("lib/**/*.rb")
  extra_files.each { |file|
    rdoc.rdoc_files.include(file) if File.exists?(file)
  }
end
