require 'active_record'

RAILS_ROOT = FAKETTP_BASE

config = File.read(File.join(FAKETTP_BASE, 'fakettp.yml'))
db_config = YAML.load(config)['database']
ActiveRecord::Base.establish_connection db_config
