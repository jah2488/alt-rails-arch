module CreatePosts
  def self.run
    sql = {
      'sqlite3' => "
        CREATE TABLE posts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          published BOOLEAN,
          name CHAR(50),
          body TEXT
        ); ",
      'postgresql' => "
        CREATE TABLE posts (
          id SERIAL PRIMARY KEY,
          published BOOLEAN,
          name VARCHAR(50),
          body TEXT
        ); "
    }
    DB.execute('DROP TABLE IF EXISTS posts') if Rails.env.test?
    DB.execute(sql[Rails.configuration.database_configuration[Rails.env]['adapter']])
  end
end
