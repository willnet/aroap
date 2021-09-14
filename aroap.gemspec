# frozen_string_literal: true

require_relative "lib/aroap/version"

Gem::Specification.new do |spec|
  spec.name          = "aroap"
  spec.version       = Aroap::VERSION
  spec.authors       = ["willnet"]
  spec.email         = ["netwillnet@gmail.com"]

  spec.summary       = "Active Record Objects Allocation Profiler"
  spec.description   = "a tool for detect places which allocate many Active Record objects"
  spec.homepage      = "https://github.com/willnet/aroap"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/willnet/aroap"
  spec.metadata["changelog_uri"] = "https://github.com/willnet/aroap/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
