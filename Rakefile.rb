$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'cucumber/rake/task'

task :default => :features
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format pretty"
end