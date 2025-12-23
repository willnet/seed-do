lib = File.expand_path('lib', __dir__)
$:.unshift lib unless $:.include?(lib)

require 'seed-do/version'

Gem::Specification.new do |s|
  s.name        = 'seed-do'
  s.version     = SeedDo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.authors     = ['Shinichi Maeshima']
  s.email       = ['netwillnet@gmail.com']
  s.homepage    = 'http://github.com/willnet/seed-do'
  s.summary     = 'Easily manage seed data in your Active Record application'
  s.description = 'Seed Do is an attempt to once and for all solve the problem of inserting and maintaining seed data in a database. It uses a variety of techniques gathered from various places around the web and combines them to create what is hopefully the most robust seed data system around.'
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'activerecord', '>= 7.1'
  s.add_dependency 'activesupport', '>= 7.1'

  s.add_development_dependency 'rspec'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.require_path = 'lib'
  s.metadata['rubygems_mfa_required'] = 'true'
end
