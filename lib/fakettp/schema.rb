# Sorry, but can't get it to work without this.
# http://github.com/kerryb/fakettp/issues#issue/2
require 'rubygems'

require File.dirname(__FILE__) + '/db'

ActiveRecord::Schema.define do
  create_table :expectations, :force => true do |t|
    t.text :contents
    t.boolean :executed, :default => false
  end

  create_table :errors, :force => true do |t|
    t.text :message
    t.integer :line_number
    t.integer :expectation_id
  end
end
