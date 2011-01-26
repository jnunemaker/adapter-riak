# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "adapter/riak/version"

Gem::Specification.new do |s|
  s.name        = "adapter-riak"
  s.version     = Adapter::Riak::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Nunemaker"]
  s.email       = ["nunemaker@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Adapter for riak}
  s.description = %q{Adapter for riak}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'adapter', '~> 0.5.1'
  s.add_dependency 'riak-client', '~> 0.8.3'
  s.add_dependency 'activesupport', '~> 3.0.3'
end
