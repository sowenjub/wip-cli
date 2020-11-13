require_relative 'lib/wip/version'

Gem::Specification.new do |spec|
  spec.name          = "wip-cli"
  spec.version       = Wip::VERSION
  spec.authors       = ["Arnaud Joubay"]

  spec.summary       = %q{A CLI for wip.co}
  spec.description   = %q{A simple gem to manage wip.co todos from the command line.}
  spec.homepage      = "https://github.com/sowenjub/wip-cli"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sowenjub/wip-cli"
  spec.metadata["changelog_uri"] = "https://github.com/sowenjub/wip-cli/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'tzinfo', "~> 2.0"

  spec.add_development_dependency 'byebug', "~> 11.0"
  spec.add_development_dependency 'rake', "~> 13.0"
  spec.add_development_dependency 'rspec', "~> 3.9"

  spec.add_runtime_dependency "thor", "~> 1.0"
end
