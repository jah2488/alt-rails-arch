module Repository

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def map(hsh)
      define_method :mapping do
        @mapping ||= hsh
      end
    end
    def for_model(model_name, options = {})
      define_method :model do
        model_name
      end
      define_method :model_method do
        options.fetch(:meth)
      end
    end
  end

  attr_reader :query

  def initialize(table_name = nil, column_names = nil, query = Query.new)
    @table_name   = table_name
    @column_names = column_names
    @query = query
  end

  def table_name
    @table_name || self.class.name.gsub("Repository", "").downcase
  end

  def column_names
    @column_names ||= (
      results = get_records_from_query("SELECT * FROM #{table_name} LIMIT 0;", include_column_names: true)
      if results.respond_to?(:fields)
        results.fields
      else
        results.first
      end
    )
  end

  def first
    limit(1).execute
  end

  def all
    execute
  end

  def pluck(*attrs)
    results = get_records_from_query(select(*([:id] | attrs)).query.sql, no_log: true).drop(1)
    results.map! { |set| set.drop(1) } if results.first && results.first.length > 1
    results
  end

  def order(attr)
    field, direction = attr.first
    new(@query.set_order("ORDER BY \"#{field}\" #{direction}"))
  end

  def offset(amt = -1)
    new(@query.set_offset("OFFSET #{amt}"))
  end

  def limit(amt = -1)
    new(@query.set_limit("LIMIT #{amt}"))
  end

  def insert(attrs)
    raise 'The passed in object must respond to #keys and #values. Maybe you meant to pass a hash?' unless attrs.respond_to?(:keys) && attrs.respond_to?(:values)
    sql = """ INSERT INTO #{table_name} (#{select_attrs(*attrs.keys, translate: true)}) VALUES (#{select_attrs(*attrs.values)}); """
    perform_query(sql)
  end

  def raw_execute
    get_records_from_query(@query.sql, include_column_names: false)
  end

  def execute
    if @query.select.nil?
      sql = @query.set_select("SELECT * FROM #{table_name}").sql
    else
      sql = @query.sql
    end
    perform_query(sql)
  end

  def to_a
    execute
  end

  protected

  def model_meth
    :new
  end

  def mapping
    {}
  end

  def select_query
    @query.select
  end

  def select(*attrs)
    if attrs.length == 1 && attrs.first.is_a?(String)
      fields = attrs.first
    else
      fields = select_attrs(*attrs, translate: true)
    end
    new(@query.set_select("SELECT #{fields} FROM #{table_name}"))
  end

  def where(query, connector = "AND")
    if query.respond_to?(:keys)
      query = query.map { |k, v| "#{mapping.fetch(k, k)} = '#{v}'" }.join(' ' + connector + ' ')
    end
    if @query.where
      new(@query.chain_where("#{connector} #{query}"))
    else
      new(@query.set_where("WHERE #{query}"))
    end
  end

  def new(query)
    self.class.new(table_name, column_names, query)
  end

  private

  def select_attrs(*attrs, translate: false)
    return "*" if attrs.empty?
    Array(attrs).map do |attr|
      if translate
        "#{mapping.fetch(attr, attr).to_s}"
      else
        "'#{attr.to_s.gsub("'", "''")}'"
      end
    end.join(", ")
  end

  def translate_field(field)
    mapping.invert.fetch(field.to_sym, field.to_sym)
  end

  def perform_query(sql, opts = {})
    results = get_records_from_query(sql, opts)
    if results.respond_to?(:fields)
      results.map do |row|
        model.public_send(model_meth, **(Hash[row.map { |k, v| [translate_field(k), v] }]))
      end
    else
      columns = results.shift
      results.map do |row|
        attr_hash    = Hash[column_names.map(&method(:translate_field)).zip([nil] * column_names.count)]
        results_hash = Hash[columns.map(&method(:translate_field)).zip(row)]
        model_attr_hash = attr_hash.merge(results_hash)
        model.public_send(model_meth, **model_attr_hash)
      end
    end
  end

  def get_records_from_query(sql, opts = {})
    DB.execute(sql, { include_column_names: true }.merge(opts))
  end
end
