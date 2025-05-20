ActiveRecord::Base.configurations = {
  'test' => {
    :adapter => "sqlite3",
    :database => File.dirname(__FILE__) + "/test.sqlite3"
  }
}

ActiveRecord::Base.establish_connection
