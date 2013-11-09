# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rudy"
  s.version = "1.9.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Delano Mandelbaum"]
  s.date = "2013-11-09"
  s.description = "Rudy: a modern scripting tool for building, deploying, and maintaining."
  s.email = "rudy@solutious.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.homepage = "https://github.com/delano/rudy"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "rudy"
  s.rubygems_version = "1.8.23"
  s.summary = "Rudy: a modern scripting tool for building, deploying, and having a good time."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<addressable>, ["= 2.2.6"])
      s.add_runtime_dependency(%q<yajl-ruby>, ["= 1.1.0"])
      s.add_runtime_dependency(%q<mustache>, ["= 0.99.3"])
      s.add_runtime_dependency(%q<gibbler>, ["= 0.8.9"])
      s.add_runtime_dependency(%q<redis>, ["= 2.2.2"])
      s.add_runtime_dependency(%q<redis-dump>, ["= 0.3.2"])
      s.add_runtime_dependency(%q<sysinfo>, ["= 0.7.3"])
      s.add_runtime_dependency(%q<annoy>, ["= 0.5.6"])
      s.add_runtime_dependency(%q<rye>, ["= 0.9.9"])
      s.add_runtime_dependency(%q<drydock>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, ["= 0.7.7"])
      s.add_development_dependency(%q<tryouts>, [">= 0"])
    else
      s.add_dependency(%q<addressable>, ["= 2.2.6"])
      s.add_dependency(%q<yajl-ruby>, ["= 1.1.0"])
      s.add_dependency(%q<mustache>, ["= 0.99.3"])
      s.add_dependency(%q<gibbler>, ["= 0.8.9"])
      s.add_dependency(%q<redis>, ["= 2.2.2"])
      s.add_dependency(%q<redis-dump>, ["= 0.3.2"])
      s.add_dependency(%q<sysinfo>, ["= 0.7.3"])
      s.add_dependency(%q<annoy>, ["= 0.5.6"])
      s.add_dependency(%q<rye>, ["= 0.9.9"])
      s.add_dependency(%q<drydock>, [">= 0"])
      s.add_dependency(%q<httparty>, ["= 0.7.7"])
      s.add_dependency(%q<tryouts>, [">= 0"])
    end
  else
    s.add_dependency(%q<addressable>, ["= 2.2.6"])
    s.add_dependency(%q<yajl-ruby>, ["= 1.1.0"])
    s.add_dependency(%q<mustache>, ["= 0.99.3"])
    s.add_dependency(%q<gibbler>, ["= 0.8.9"])
    s.add_dependency(%q<redis>, ["= 2.2.2"])
    s.add_dependency(%q<redis-dump>, ["= 0.3.2"])
    s.add_dependency(%q<sysinfo>, ["= 0.7.3"])
    s.add_dependency(%q<annoy>, ["= 0.5.6"])
    s.add_dependency(%q<rye>, ["= 0.9.9"])
    s.add_dependency(%q<drydock>, [">= 0"])
    s.add_dependency(%q<httparty>, ["= 0.7.7"])
    s.add_dependency(%q<tryouts>, [">= 0"])
  end
end

