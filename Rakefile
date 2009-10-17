require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'redcloth'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fakettp"
    gem.summary = %Q{HTTP server mocking tool}
    gem.description = gem.summary
    gem.email = "kerryjbuckley@gmail.com"
    gem.homepage = "http://github.com/kerryb/fakettp"
    gem.authors = ["Kerry Buckley"]
    gem.add_dependency 'sinatra-sinatra', '>=0.9.2'
    gem.add_development_dependency 'rcov'
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "cucumber"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end
task :spec => :create_readme

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ['--exclude', 'spec']
end

task :spec => :check_dependencies

desc 'Check spec coverage'
RCov::VerifyTask.new(:verify_rcov) do |t|
  t.threshold = 100.0
  t.index_html = 'coverage/index.html'
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fakettp2 #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
 
# -------------------------------------------------------

desc 'remove all build products'
task :clean do
  FileUtils.rm_rf %w(install README.html coverage pkg)
end

desc 'run specs, create gem, install and test'
task :default => [:rcov, :verify_rcov, :create_readme, :gemspec, :build, :local_install, :test_install, :features]

desc 'Create README.html from README.textile'
task :create_readme do
  File.open 'README.html', 'w' do |f|
    f.write RedCloth.new(File.read('README.textile')).to_html
  end
end

task :local_install do
  system 'gem in -l pkg/*'
end

desc 'Install FakeTTP into local install directory'
task :test_install do
  rm_rf 'install'
  system 'fakettp install install'
  touch 'install/tmp/restart.txt'
end
