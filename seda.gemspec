# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seda/version'

Gem::Specification.new do |spec|
  spec.name          = "seda"
  spec.version       = Seda::VERSION
  spec.authors       = ["Alexander Aleksanyan"]
  spec.email         = ["alex1100.software@gmail.com"]

  spec.summary       = %q{Familiar Methods From Underscore/Lodash}
  spec.description   = %q{Familiar Methods From Underscore and Lodash Ported Over To Ruby}
  spec.homepage      = "https://github.com/Alex1100/seda"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard"
end
