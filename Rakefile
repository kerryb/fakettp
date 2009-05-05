require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'cucumber/rake/task'
require 'redcloth'

$:.unshift(File.dirname(__FILE__) + '/../../lib')
 
GEM = "fakettp"
GITHUB_USER = "kerryb"
GEM_VERSION = "0.2.4.1"
SUMMARY = "HTTP server mocking tool"
AUTHOR = "Kerry Buckley"
EMAIL = "kerryjbuckley@gmail.com"
HOMEPAGE = "http://github.com/#{GITHUB_USER}/#{GEM}/"
 
spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.has_rdoc = true
  s.add_dependency('sinatra-sinatra', '>=0.9.1.3')
  s.add_development_dependency('rspec', '>=1.1.12')
  s.add_development_dependency('spicycode-rcov', '>=0.8.0')
  s.add_development_dependency('cucumber', '>=0.1.16')
  s.add_development_dependency('RedCloth', '>=4.1.1')
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*', 'bin/**/*', 'README.html'].to_a
  s.executables = %w(fakettp)  
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.rubyforge_project = GEM # GitHub bug, gem isn't being built when this is missed
end

desc 'remove all build products'
task :clean do
  FileUtils.rm_rf %w(install README.html coverage pkg)
end

desc 'run specs, create gem, install and test'
task :default => [:verify_rcov, :create_readme, :test_install, :features]

desc 'Run specs'
Spec::Rake::SpecTask.new(:spec => :create_readme) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end

desc 'Check spec coverage'
RCov::VerifyTask.new(:verify_rcov => :spec) do |t|
  t.threshold = 100.0
  t.index_html = 'coverage/index.html'
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

namespace :gem do
  desc "Install the gem locally"
  task :install => [:make_spec, :repackage, :uninstall] do
    sh %{sudo gem install -l pkg/#{GEM}-#{GEM_VERSION}}
  end
  
  desc 'Remove all installed versions of gem'
  task :uninstall do
    system %{sudo gem uninstall -xa #{GEM} #{GITHUB_USER}-#{GEM}}
  end
  
  desc 'Revert to the public gem'
  task :revert => :uninstall do
    system %{sudo gem install #{GITHUB_USER}-#{GEM}}
  end
end

desc 'Install FakeTTP into local install directory'
task :test_install => :'gem:install' do
  rm_rf 'install'
  system 'fakettp install install'
  touch 'install/tmp/restart.txt'
end

desc 'run integration tests'
task :features do
  system 'cucumber'
end
