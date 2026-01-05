require 'rubygems'
require 'bundler/setup'
require 'seed-do'
require 'logger'

SeedDo.quiet = true

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/../debug.log')
ENV['RAILS_ENV'] ||= 'test'
ENV['DB'] ||= 'sqlite3'

puts "Using #{ENV.fetch('DB', nil)} to run the tests."
require File.dirname(__FILE__) + "/connections/#{ENV.fetch('DB', nil)}.rb"

ActiveRecord::Schema.define version: 0 do
  create_table :seeded_models, force: true do |t|
    t.column :login, :string
    t.column :first_name, :string
    t.column :last_name, :string
    t.column :title, :string
  end

  create_table :bulk_seeded_models, force: true do |t|
    t.column :login, :string
    t.column :first_name, :string
    t.column :last_name, :string
    t.column :title, :string
    t.index :title, unique: true
  end

  create_table :seeded_model_no_primary_keys, id: false, force: true do |t|
    t.column :id, :string
  end

  create_table :seeded_model_no_sequences, id: false, force: true do |t|
    t.column :id, :string
  end

  execute('ALTER TABLE seeded_model_no_sequences ADD PRIMARY KEY (id)') if ENV['DB'] == 'postgresql'
end

class SeededModel < ActiveRecord::Base
  validates_presence_of :title
  attr_accessor :fail_to_save

  before_save { throw(:abort) if fail_to_save }
end

class BulkSeededModel < ActiveRecord::Base
end

class SeededModelNoPrimaryKey < ActiveRecord::Base
end

class SeededModelNoSequence < ActiveRecord::Base
end

RSpec.configure do |config|
  config.before do
    SeededModel.delete_all
    BulkSeededModel.delete_all
  end
end
