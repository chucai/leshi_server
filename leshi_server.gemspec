# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "leshi_server"
  s.authors = ["何旭东"]
  s.email = ["hexudong08@gmail.com"]
  s.summary = "leshi_server web interface"
  s.description = "for video play"
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.1"
end