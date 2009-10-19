# TODO: this is evil, but I can't get it to work without.
# http://gist.github.com/54177
require 'rubygems'
require 'activerecord'

RAILS_ROOT = FAKETTP_BASE

config = File.read(File.join(FAKETTP_BASE, 'fakettp.yml'))
db_config = YAML.load(config)['database']
ActiveRecord::Base.establish_connection db_config
