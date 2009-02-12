require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
require 'cucumber/rake/task'
require 'redcloth'

$:.unshift(File.dirname(__FILE__) + '/../../lib')
 
GEM = "fakettp"
GEM_VERSION = "0.1.0"
SUMMARY = "HTTP server mocking tool"
AUTHOR = "Kerry Buckley"
EMAIL = "kerryjbuckley@gmail.com"
HOMEPAGE = "http://github.com/kerryb/fakettp/"
 
spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.has_rdoc = true
  s.add_dependency('sinatra', '>=0.3.0')
  s.add_development_dependency('rspec', '>=1.1.12')
  s.add_development_dependency('cucumber', '>=0.1.16')
  s.add_development_dependency('RedCloth', '>=4.1.1')
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*', 'bin/**/*', 'README.html'].to_a
  s.bindir = 'bin'
  
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE

  s.rubyforge_project = GEM # GitHub bug, gem isn't being build when this is missed
end

desc 'run specs and create gem'
task :default => [:spec, :create_readme, :test_install, :features]

desc 'run integration tests'
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format pretty"
end

desc 'Run specs'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end

desc 'Create README.html from README.textile'
task :create_readme do
  File.open 'README.html', 'w' do |f|
    f.write RedCloth.new(File.read('README.textile')).to_html
  end
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
 
desc "Install the gem locally"
task :install_gem => [:make_spec, :repackage] do
  sh %{sudo gem install -l pkg/#{GEM}-#{GEM_VERSION}}
end

desc 'Install FakeTTP into local install directory'
task :test_install => :install_gem do
  rm_rf 'install'
  system 'fakettp install install'
  touch 'install/tmp/restart.txt'
end
