require 'active_record'
require 'active_support/core_ext/module/attribute_accessors'
require 'seed-do/railtie' if defined?(Rails)

module SeedDo
  autoload :VERSION,               'seed-do/version'
  autoload :Seeder,                'seed-do/seeder'
  autoload :ActiveRecordExtension, 'seed-do/active_record_extension'
  autoload :BlockHash,             'seed-do/block_hash'
  autoload :Runner,                'seed-do/runner'
  autoload :Writer,                'seed-do/writer'

  # Set `SeedDo.quiet = true` to silence all output
  mattr_accessor :quiet, default: false

  # Set this to be an array of paths to directories containing your seed files. If used as a Rails
  # plugin, SeedDo will set it to contain `Rails.root/db/fixtures` and
  # `Rails.root/db/fixtures/Rails.env`
  mattr_accessor :fixture_paths, default: ['db/fixtures']

  # Load seed data from files
  # @param [Array] fixture_paths The paths to look for seed files in
  # @param [Regexp] filter If given, only filenames matching this expression will be loaded
  def self.seed(fixture_paths = SeedDo.fixture_paths, filter = nil)
    Runner.new(fixture_paths, filter).run
  end
end

# @public
ActiveSupport.on_load(:active_record) do
  extend SeedDo::ActiveRecordExtension
end
