require 'zlib'
require 'active_support/core_ext/array/wrap'

module SeedDo
  # Runs seed files.
  #
  # It is not recommended to use this class directly. Instead, use {SeedDo.seed SeedDo.seed}, which creates
  # an instead of {Runner} and calls {#run #run}.
  #
  # @see SeedDo.seed SeedDo.seed
  class Runner
    attr_accessor :buffer
    attr_reader :bulk

    # @param [Array<String>] fixture_paths The paths where fixtures are located. Will use
    #   `SeedDo.fixture_paths` if {nil}. If the argument is not an array, it will be wrapped by one.
    # @param [Regexp] filter If given, only seed files with a file name matching this pattern will
    #   be used
    # @param [Boolean] bulk If true, use upsert_all to insert/update records in bulk
    def initialize(fixture_paths = nil, filter = nil, bulk: false)
      @fixture_paths = Array.wrap(fixture_paths || SeedDo.fixture_paths)
      @filter        = filter
      @bulk          = bulk
    end

    # Run the seed files.
    def run
      SeedDo.current_runner = self
      puts "\n== Filtering seed files against regexp: #{@filter.inspect}" if @filter && !SeedDo.quiet

      filenames.each do |filename|
        run_file(filename)
      end
    ensure
      SeedDo.current_runner = nil
    end

    private

    def run_file(filename)
      puts "\n== Seed from #{filename}" unless SeedDo.quiet

      ActiveRecord::Base.transaction do
        if bulk
          with_buffer { _run_file(filename) }
        else
          _run_file(filename)
        end
      end
    end

    def with_buffer
      self.buffer = { seed: [], seed_once: [] }
      yield
      process_buffer
    ensure
      self.buffer = nil
    end

    def _run_file(filename)
      open(filename) do |file|
        chunked_ruby = +''
        file.each_line do |line|
          if line == "# BREAK EVAL\n"
            eval(chunked_ruby)
            chunked_ruby = +''
          else
            chunked_ruby << line
          end
        end
        eval(chunked_ruby) unless chunked_ruby == ''
      end
    end

    def process_buffer
      return unless buffer

      buffer.each do |type, operations|
        next if operations.empty?

        operations.chunk { |op| [op[:model], op[:constraints]] }
                  .each do |(model, constraints), chunk|
          flush_chunk(model, constraints, type, chunk)
        end
      end
    end

    def flush_chunk(model, constraints, type, chunk)
      all_data = chunk.flat_map { |op| op[:data] }

      if type == :seed
        model.upsert_all(all_data, unique_by: constraints)
      elsif type == :seed_once
        model.upsert_all(all_data, unique_by: constraints, on_duplicate: :skip)
      end
    end

    def open(filename, &)
      if filename[-3..-1] == '.gz'
        Zlib::GzipReader.open(filename, &)
      else
        File.open(filename, &)
      end
    end

    def filenames
      filenames = []
      @fixture_paths.each do |path|
        filenames += (Dir[File.join(path, '*.rb')] + Dir[File.join(path, '*.rb.gz')]).sort
      end
      filenames.uniq!
      filenames = filenames.find_all { |filename| filename =~ @filter } if @filter
      filenames
    end
  end
end
