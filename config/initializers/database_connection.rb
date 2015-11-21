module DB
  def self.connection
    @db_connection ||= (
      SQLite3::Database.new(Rails.configuration.database_configuration[Rails.env]['database']).tap do |db|
        db.type_translation = true
      end
    )
  end
end
