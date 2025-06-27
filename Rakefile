# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

desc "Run benchmarks"
task :bench do
  require "benchmark"
  require "ryaml"
  require "yaml"

  str = "YAML: 42\nJSON: six".freeze
  N = 100_000
  ryaml = Ryaml::Parser.new(str)
  yaml = YAML.parse(str)

  Benchmark.bm do |x|
    x.report("test file stdlib") { N.times { yaml.to_ruby } }
    x.report("test file ryaml") { N.times { ryaml.parse; ryaml.lines_enum.rewind } }
  end
end

task default: :test
