require "yaml"
require "pf2"
N = 10000
yaml_string = File.read("./samples/mapping.yml")
file = File.expand_path(__FILE__)
basename = "#{File.dirname(file)}/#{File.basename(file, ".rb")}"

profile = Pf2.profile do
  N.times { YAML.parse(yaml_string) }
end

File.write("#{basename}.pf2profile", profile)
