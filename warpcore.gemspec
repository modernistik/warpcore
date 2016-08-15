# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'warpcore/version'

Gem::Specification.new do |spec|
  spec.name          = "warpcore"
  spec.version       = WarpCore::VERSION
  spec.authors       = ["Anthony Persaud"]
  spec.email         = ["persaud@modernistik.com"]

  spec.summary       = %q{Components for a modern scalable api server infrastructure with Ruby.}
  spec.description   = %q{A set of components and classes for quickly building cloud applications and infrastructure.}
  spec.homepage      = "https://github.com/modernistik/warpcore"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.2.2'

  spec.add_runtime_dependency "activesupport",  ['>= 4.2.1', '< 6']
  spec.add_runtime_dependency "parse-stack", '~> 1'
  spec.add_runtime_dependency "redis", ['> 2', '< 4']
  spec.add_runtime_dependency "sucker_punch", '~> 2'
  spec.add_runtime_dependency "sidekiq", '~> 4'
  spec.add_runtime_dependency "moneta", '~> 0'
  spec.add_runtime_dependency "dotenv", "~> 2"
  spec.add_runtime_dependency "thor", "~> 0"
  spec.add_runtime_dependency "rake", "~> 11"
  spec.add_runtime_dependency "puma", '~> 3'
  spec.add_runtime_dependency "foreman", '~> 0'

  spec.add_development_dependency "bundler", "~> 1.12"

end
