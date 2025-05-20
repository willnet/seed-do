ActiveRecord::Base.configurations = {
  'test' => {
    :adapter  => "mysql2",
    :database => "seed_do_test",
    :username => "root",
    :host     => "127.0.0.1",
  }
}
ActiveRecord::Tasks::DatabaseTasks.create_current('test')
