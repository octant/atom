# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','atom_version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'atom'
  s.version = Atom::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
# Add your other files here if you make them
  s.files = %w(
bin/atom
lib/atom_version.rb
lib/atom.rb
lib/atom/scaffold.rb
lib/atom/generate.rb
lib/atom/helpers.rb
lib/atom/plugin.rb
lib/atom/plugger.rb
)
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.textile','atom.rdoc']
  s.rdoc_options << '--title' << 'atom' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'atom'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba', '~> 0.4.6')
  s.add_runtime_dependency('gli')
  s.add_runtime_dependency('mustache')
  s.add_runtime_dependency('RedCloth')
end
