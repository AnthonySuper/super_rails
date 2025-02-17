# frozen_string_literal: true

require_relative "lib/super_typed/version"

Gem::Specification.new do |spec|
  spec.name = "super_typed"
  spec.version = SuperTyped::VERSION
  spec.authors = ["Anthony Super"]
  spec.email = ["anthony@noided.media"]

  spec.summary = "Types for your supercharged rails app"
  spec.homepage = "https://github.com/AnthonySuper/super_rails/"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/AnthonySuper/super_rails/"
  spec.metadata["changelog_uri"] = "https://github.com/AnthonySuper/super_rails/tree/main/super_typed"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
