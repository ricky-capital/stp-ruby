# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stp/version"

Gem::Specification.new do |spec|
  spec.name          = "stp"
  spec.version       = Stp::VERSION
  spec.authors       = ["Daniel Infante Vargas"]
  spec.email         = ["daninfpj@gmail.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/ricky-capital/stp-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.11.1"
  spec.add_dependency "activesupport", ">= 3.1"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rails", [">= 3.1"]
  spec.add_development_dependency "rspec-rails", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry-byebug"
end
