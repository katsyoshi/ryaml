require "benchmark"
require "ryaml"
require "yaml"

N = 10000
yaml_string = File.read("./samples/mapping.yml")
ryaml = Ryaml::Parser.new(yaml_string)

Benchmark.bm do |x|
  x.report("YAML parse:") { N.times { YAML.load(yaml_string) } }
  x.report("RYAML::Parser#.parse:") { N.times { Ryaml::Parser.parse(yaml_string) } }
  x.report("RYAML::Parser.parse:") { N.times { ryaml.parse; ryaml.lines_enum.rewind } }
end
