# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/bundle_audit/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-bundle_audit"
  spec.version       = Capistrano::BundleAudit::VERSION
  spec.authors       = ["Chris Beer"]
  spec.email         = ["cabeer@stanford.edu"]
  spec.summary       = %q{Audit a project's gem dependencies before deployment}
  spec.homepage      = ""
  spec.license       = "Apache 2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", "~> 3.0"
  spec.add_dependency "bundler-audit", "~> 0.5"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
