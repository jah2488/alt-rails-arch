require 'query'
require 'repository'

module DB

  def self.connection
    @db_connection ||= set_connection
  end

  def self.execute(sql, options = {})
    connection.execute(sql, options)
  end

  def self.set_connection
    db_config = Rails.configuration.database_configuration[Rails.env]
    case db_config['adapter']
    when 'sqlite3'    then SqliteAdapter.new(db_config)
    when 'postgresql' then PostgresAdapter.new(db_config)
    else
      raise "Unknown Adapter: #{db_config['adapter']}\n Supported Adapters: sqlite3, postgresql"
    end
  end

  class Adapter

    def initialize(config)
      @config = config
      @connection = connect(@config)
    end

    def raw_connection
      @connection
    end

    def connect(config)
      abort 'Override this method'
    end

    def execute(sql, options = {})
      results = []
      time = Benchmark.ms do
        if block_given?
          results = yield
        else
          abort 'Override this method'
        end
      end
      unless options[:no_log]
        $count = $count.to_i
        Rails.logger.info "[#{$count}][#{time.round(2).to_s.rjust(4)}ms][#{results.length.to_s.rjust(3)} rows][#{sql.strip}]" if Rails.logger
        $count += 1
      end
      results
    end
  end

  class SqliteAdapter < Adapter
    def connect(config)
      SQLite3::Database.new(config['database']).tap do |db|
        db.type_translation = true
      end
    end

    def execute(sql, options = {})
      super(sql, options) do
        begin
          @connection.transaction do |db|
            if options[:include_column_names]
              return db.execute2(sql)
            else
              return db.execute(sql)
            end
          end
        rescue SQLite3::SQLException => e
          Rails.logger.fatal sql.inspect if Rails.logger
          raise e
        end
      end
    end
  end

  class PostgresAdapter < Adapter
    def connect(config)
      system("createdb #{config['database']}")
      conn = PG::Connection.open(dbname: ENV["DATABASE_URL"] || config['database'])
      fail "Connect to PostgresDB failed: #{conn.error_message}" unless conn.status == PG::CONNECTION_OK
      conn.type_map_for_results = PG::BasicTypeMapForResults.new(conn)
      conn.type_map_for_queries = PG::BasicTypeMapForQueries.new(conn)
      conn
    end

    def execute(sql, options = {})
      super(sql, options) do |results|
        begin
          return @connection.query(sql)
        rescue PG::Error => e
          Rails.logger.fatal sql.inspect if Rails.logger
          raise e
        end
      end
    end
  end

end
