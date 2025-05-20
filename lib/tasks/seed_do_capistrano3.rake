namespace :db do
  desc 'Load seed data into database'
  task :seed_do do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:seed_do'
        end
      end
    end
  end
end
