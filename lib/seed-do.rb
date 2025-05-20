require 'active_record'
require 'active_support/core_ext/module/attribute_accessors'
require 'seed-do/railtie' if defined?(Rails) && Rails.version >= "3"

module SeedDo
  autoload :VERSION,               'seed-do/version'
  autoload :Seeder,                'seed-do/seeder'
  autoload :ActiveRecordExtension, 'seed-do/active_record_extension'
  autoload :BlockHash,             'seed-do/block_hash'
  autoload :Runner,                'seed-do/runner'
  autoload :Writer,                'seed-do/writer'

  mattr_accessor :quiet

  # Set `SeedDo.quiet = true` to silence all output
  @@quiet = false

  mattr_accessor :fixture_paths

  # Set this to be an array of paths to directories containing your seed files. If used as a Rails
  # plugin, SeedDo will set to to contain `Rails.root/db/fixtures` and
  # `Rails.root/db/fixtures/Rails.env`
  @@fixture_paths = ['db/fixtures']

  # Load seed data from files
  # @param [Array] fixture_paths The paths to look for seed files in
  # @param [Regexp] filter If given, only filenames matching this expression will be loaded
  def self.seed(fixture_paths = SeedDo.fixture_paths, filter = nil)
    Runner.new(fixture_paths, filter).run
  end
end

# @public
class ActiveRecord::Base
  extend SeedDo::ActiveRecordExtension
end
