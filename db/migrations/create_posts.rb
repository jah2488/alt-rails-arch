module CreatePosts
  def self.run
    ::DB.connection.execute <<-SQL
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        published boolean,
        name char(50),
        body text
      );
    SQL
  end
end
