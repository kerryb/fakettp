require File.dirname(__FILE__) + '/db'

ActiveRecord::Schema.define do
  create_table :expectations, :force => true do |t|
    t.text :contents
    t.boolean :executed, :default => false
  end
end