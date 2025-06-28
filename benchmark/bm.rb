require "benchmark"
require "benchmark/ips"
require "ryaml"
require "yaml"

N = 10_000
yaml_string = File.read("./samples/mapping.yml")
ryaml = Ryaml::Parser.new(yaml_string)

puts "YJIT DISABLED"
Benchmark.bm do |x|
  x.report("YAML#.load:") { N.times { YAML.load(yaml_string) } }
  x.report("RYAML::Parser#.parse:") { N.times { Ryaml::Parser.parse(yaml_string) } }
  x.report("RYAML::Parser#parse!:") { N.times { ryaml.parse! } }
  x.report("RYAML::Parser#parse:") { N.times { ryaml.parse; ryaml.rewind } }
  return unless defined?(RubyVM::YJIT)
end

Benchmark.ips do |x|
  x.report("YAML#.load:") { YAML.load(yaml_string) }
  x.report("RYAML::Parser#.parse:") { Ryaml::Parser.parse(yaml_string) }
  x.report("RYAML::Parser#parse!:") { ryaml.parse! }
  x.report("RYAML::Parser#parse:") { ryaml.parse; ryaml.rewind }
end

exit unless defined? RubyVM::YJIT
puts "YJIT ENABLED"

RubyVM::YJIT.enable
Benchmark.bm do |x|
  x.report("YAML#.load:") { N.times { YAML.load(yaml_string) } }
  x.report("RYAML::Parser#.parse:") { N.times { Ryaml::Parser.parse(yaml_string) } }
  x.report("RYAML::Parser#parse!:") { N.times { ryaml.parse! } }
  x.report("RYAML::Parser#parse:") { N.times { ryaml.parse; ryaml.rewind } }
end

Benchmark.ips do |x|
  x.report("YAML#.load:") { YAML.load(yaml_string) }
  x.report("RYAML::Parser#.parse:") { Ryaml::Parser.parse(yaml_string) }
  x.report("RYAML::Parser#parse!:") { ryaml.parse! }
  x.report("RYAML::Parser#parse:") { ryaml.parse; ryaml.rewind }
end
