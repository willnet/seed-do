module SeedDo
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/seed_do.rake'
    end

    initializer 'seed_do.set_fixture_paths' do
      SeedDo.fixture_paths = [
        Rails.root.join('db/fixtures').to_s,
        Rails.root.join('db/fixtures/' + Rails.env).to_s
      ]
    end
  end
end
