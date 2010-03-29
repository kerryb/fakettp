require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

desc 'run specs, create gem, install and test'
task :default => [:rcov, :verify_rcov, :gemspec, :build, :local_install, :test_install, :'cucumber:all', :ok]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fakettp"
    gem.summary = %Q{HTTP server mocking tool}
    gem.description = gem.summary
    gem.email = "kerryjbuckley@gmail.com"
    gem.homepage = "http://github.com/kerryb/fakettp"
    gem.authors = ["Kerry Buckley"]
    gem.add_dependency 'sinatra', '0.9.4'
    gem.add_dependency 'sqlite3-ruby', '1.2.5'
    gem.add_dependency 'activerecord', '2.3.4'
    gem.add_dependency 'rspec'
    gem.add_development_dependency 'jeweler'
    gem.add_development_dependency 'rcov'
    gem.add_development_dependency 'rack-test'
    gem.add_development_dependency 'cucumber'
    gem.add_development_dependency 'nokogiri'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ['--exclude', 'spec', '--exclude', ENV['GEM_HOME']]
end

task :spec => :check_dependencies

desc 'Check spec coverage'
RCov::VerifyTask.new(:verify_rcov) do |t|
  t.threshold = 100.0
  t.index_html = 'coverage/index.html'
end

begin
  require 'cucumber/rake/task'
  namespace :cucumber do
    Cucumber::Rake::Task.new({:ok => :check_dependencies}, 'Run features that should pass') do |t|
      t.cucumber_opts = "--color --tags ~@wip --strict --format 'pretty'"
    end

    Cucumber::Rake::Task.new({:wip => :check_dependencies}, 'Run features that are being worked on') do |t|
      t.cucumber_opts = "--color --tags @wip:2 --wip --format 'pretty'"
    end

    desc 'Run all features'
    task :all => [:ok, :wip]
  end
  desc 'Alias for cucumber:ok'
  task :cucumber => 'cucumber:ok'
rescue LoadError
  task :cucumber do
    abort "Cucumber is not available. In order to run features, you must: gem install cucumber"
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

desc 'remove all build products'
task :clean do
  FileUtils.rm_rf %w(tmp install coverage pkg)
end

task :local_install do
  system "gem in -l pkg/fakettp-#{File.read('VERSION').chomp}.gem"
end

desc 'Install FakeTTP into local install directory'
task :test_install do
  rm_rf 'install'
  system 'fakettp install install fakettp.local'
  touch 'install/tmp/restart.txt'
end

task :ok do
  red    = "\e[31m"
  yellow = "\e[33m"
  green  = "\e[32m"
  blue   = "\e[34m"
  purple = "\e[35m"
  bold   = "\e[1m"
  normal = "\e[0m"
  puts "", "#{bold}#{red}*#{yellow}*#{green}*#{blue}*#{purple}* #{green} ALL TESTS PASSED #{purple}*#{blue}*#{green}*#{yellow}*#{red}*#{normal}"
end
