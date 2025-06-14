files = ['libyaml.rb', 'ryaml.rb',]

files.each do |file|
  f = File.expand_path(file, __dir__)
  exe = "ruby #{f}"
  basedir = File.dirname(File.expand_path(f))
  basename = basedir + "/" + File.basename(f, ".rb")
  result = basename + ".pf2profile"
  IO.popen(exe, "r+")
  sleep 1
  IO.popen("pf2 report -o #{basename}.json #{result}", "r+")
end
