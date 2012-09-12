# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "pdf_latex"
  s.version = "0.1.0"
  s.homepage = "http://github.com/tb/pdf_latex"
  s.license = "MIT"
  s.summary = "Ruby wrapper for pdflatex"
  s.email = "t.bak@selleo.com"
  s.authors = ["Tomasz Bak"]
  s.files = Dir["{app,lib,config,db}/**/*"] + ["MIT-LICENSE", "README.rdoc"]
end

