# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

desc "Run benchmarks"
task :bench, :yjit do |_task, args|
  RubyVM::YJIT.enable if args[:yjit] && defined?(RubyVM::YJIT)
  load "./benchmark/bm.rb"
  return if !defined?(RubyVM::YJIT) || RubyVM::YJIT.enabled?
  puts nil
  RubyVM::YJIT.enable if defined?(RubyVM::YJIT)
  load "./benchmark/bm.rb"
end

task default: :test
