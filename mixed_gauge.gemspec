# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mixed_gauge/version'

Gem::Specification.new do |spec|
  spec.name          = "mixed_gauge"
  spec.version       = MixedGauge::VERSION
  spec.authors       = ["Taiki Ono"]
  spec.email         = ["taiks.4559@gmail.com"]

  spec.summary       = %q{An ActiveRecord extension for database splitting.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/taiki45/mixed_gauge"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
end
