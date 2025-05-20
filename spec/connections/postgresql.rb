ActiveRecord::Base.configurations = {
  'test' => {
    :adapter  => "postgresql",
    :database => "seed_do_test",
    :username => "postgres",
    :host     => "127.0.0.1"
  }
}
ActiveRecord::Tasks::DatabaseTasks.create_current('test')
