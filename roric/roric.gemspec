# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roric/version'

Gem::Specification.new do |spec|
  spec.name          = "roric"
  spec.version       = Roric::VERSION
  spec.authors       = ["Ricahrd Wilson"]
  spec.email         = ["r.crawfordwilson@gmail.com"]
  spec.description   = %q{Yet another IRC bot building framework.}
  spec.summary       = %q{Yet another IRC bot building framework.}
  spec.homepage      = "http://github.com/Senjai/roric"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "celluloid", "~> 0.15.0"
  spec.add_dependency "celluloid-io", "~> 0.15.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov", '~> 0.7.1'
end
