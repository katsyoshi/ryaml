require "yaml"
require "pf2"
require "ryaml"
output = $1
N = 10000
yaml_string = File.read("./samples/mapping.yml")
ryaml = Ryaml::Parser.new(yaml_string)
file = File.expand_path(__FILE__)
basename = "#{File.dirname(file)}/#{File.basename(file, ".rb")}"

profile = Pf2.profile do
  N.times { ryaml.parse; ryaml.lines_enum.rewind }
end

File.write("#{basename}.pf2profile", profile)
