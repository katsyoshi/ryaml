# frozen_string_literal: true

require_relative "lib/ryaml/version"

Gem::Specification.new do |spec|
  spec.name = "ryaml"
  spec.version = RYAML::VERSION
  spec.authors = ["MATSUMOTO, Katsuyoshi"]
  spec.email = ["github@katsyoshi.org"]

  spec.summary = "YAML parser and emitter for Ruby, with a focus on performance and simplicity."
  spec.description = "YAML parser and emitter for Ruby, with a focus on performance and simplicity. It aims to provide a fast and efficient way to handle YAML data in Ruby applications, while maintaining compatibility with the YAML specification."
  spec.homepage = "https://github.com/katsyoshi/ryaml"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
