# Seed Do

This project is a fork of [seed-fu](https://github.com/mbleigh/seed-fu).

Seed Do is an attempt to once and for all solve the problem of inserting and maintaining seed data in a database. It uses a variety of techniques gathered from various places around the web and combines them to create what is hopefully the most robust seed data system around.

## Installation

Just add `gem 'seed-do'` to your `Gemfile`

## Documentation

For detailed API documentation, please visit: https://rubydoc.info/github/willnet/seed-do

## Migrating from seed-fu

If you are migrating from seed-fu to seed-do, you'll need to make the following changes:

1. Rename all occurrences of `SeedFu` to `SeedDo` in your code
2. Update rake task references from `rake db:seed_fu` to `rake db:seed_do`

For example:

```ruby
# Before
SeedFu.seed
rake db:seed_fu

# After
SeedDo.seed
rake db:seed_do
```

Capistrano integration also needs to be updated:

```ruby
# Before
require 'seed-fu/capistrano'
# or for Capistrano3
require 'seed-fu/capistrano3'

# After
require 'seed-do/capistrano'
# or for Capistrano3
require 'seed-do/capistrano3'
```

## Basic Example


### In `db/fixtures/users.rb`

```ruby
User.seed do |s|
  s.id    = 1
  s.login = "jon"
  s.email = "jon@example.com"
  s.name  = "Jon"
end

User.seed do |s|
  s.id    = 2
  s.login = "emily"
  s.email = "emily@example.com"
  s.name  = "Emily"
end
```

### To load the data:

```ruby
$ rake db:seed_do
== Seed from /path/to/app/db/fixtures/users.rb
 - User {:id=>1, :login=>"jon", :email=>"jon@example.com", :name=>"Jon"}
 - User {:id=>2, :login=>"emily", :email=>"emily@example.com", :name=>"Emily"}
```

## Constraints

Constraints are used to identify seeds, so that they can be updated if necessary. For example:

```ruby
Point.seed(:x, :y) do |s|
  s.x = 4
  s.y = 7
  s.name = "Home"
end
```

The first time this seed is loaded, a `Point` record will be created. Now suppose the name is changed:

```ruby
Point.seed(:x, :y) do |s|
  s.x = 4
  s.y = 7
  s.name = "Work"
end
```

When this is run, Seed Do will look for a `Point` based on the `:x` and `:y` constraints provided. It will see that a matching `Point` already exists and so update its attributes rather than create a new record.

If you do not want seeds to be updated after they have been created, use `seed_once`:

```ruby
Point.seed_once(:x, :y) do |s|
  s.x = 4
  s.y = 7
  s.name = "Home"
end
```

The default constraint just checks the `id` of the record.

## Where to put seed files

By default, seed files are looked for in the following locations:

- `#{Rails.root}/db/fixtures` and `#{Rails.root}/db/fixtures/#{Rails.env}` in a Rails app
- `./db/fixtures` when loaded without Rails

You can change these defaults by modifying the `SeedDo.fixture_paths` array.

Seed files can be named whatever you like, and are loaded in alphabetical order.

## Terser syntax

When loading lots of records, the above block-based syntax can be quite verbose. You can use the following instead:

```ruby
User.seed(:id,
  { :id => 1, :login => "jon",   :email => "jon@example.com",   :name => "Jon"   },
  { :id => 2, :login => "emily", :email => "emily@example.com", :name => "Emily" }
)
```

## Rake task

Seed files can be run automatically using `rake db:seed_do`. There are two options which you can pass:

- `rake db:seed_do FIXTURE_PATH=path/to/fixtures` -- Where to find the fixtures
- `rake db:seed_do FILTER=users,articles` -- Only run seed files with a filename matching the `FILTER`

You can also do a similar thing in your code by calling `SeedDo.seed(fixture_paths, filter)`.

## Disable output

To disable output from Seed Do, set `SeedDo.quiet = true`.

## Handling large seed files

Seed files can be huge.  To handle large files (over a million rows), try these tricks:

- Gzip your fixtures.  Seed Do will read .rb.gz files happily.  `gzip -9` gives the   best compression, and with Seed Do's repetitive syntax, a 160M file can shrink to 16M.
- Add lines reading `# BREAK EVAL` in your big fixtures, and Seed Do will avoid loading the whole file into memory.  If you use `SeedDo::Writer`, these breaks are built into your generated fixtures.
- Load a single fixture at a time with the `FILTER` environment variable
- If you don't need Seed Do's ability to update seed with new data, then you may find that [activerecord-import](https://github.com/zdennis/activerecord-import) is faster

## Generating seed files

If you need to programmatically generate seed files, for example to convert a CSV file into a seed file, then you can use [`SeedDo::Writer`](lib/seed-do/writer.rb).

## Capistrano deployment

SeedDo has included Capistrano [deploy script](lib/seed-do/capistrano.rb), you just need require that
in `config/deploy.rb`:

```ruby
require 'seed-do/capistrano'

# Trigger the task after update_code
after 'deploy:update_code', 'db:seed_do'
```

If you use Capistrano3, you should require another file.

```ruby
require 'seed-do/capistrano3'

# Trigger the task before publishing
before 'deploy:publishing', 'db:seed_do'
```

## Development

### To run the specs

```
bundle install      # Install the dependencies
bundle exec rspec   # Run the specs
```

By default an sqlite3 database is used.

### To test others

```
DB=mysql2 bundle exec rspec
DB=postgresql bundle exec rspec
```

The connection paramaters for each of these are specified in spec/connections/, which you can edit if necessary (for example to change the username/password).

## Original Author

[Michael Bleigh](http://www.mbleigh.com/) is the original author

Copyright © 2008-2010 Michael Bleigh, released under the MIT license
