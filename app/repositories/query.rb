class Query
  attr_reader :select, :where, :order, :limit, :offset
  def initialize(select = nil, where = nil, order = nil, limit = nil, offset = nil)
    self.select = select
    self.where  = where
    self.order  = order
    self.limit  = limit
    self.offset = offset
  end

  def sql
    [select, where, order, offset, limit].compact.join(" ") + ";"
  end

  def set_select(select) new(select: select) end
  def set_where(where)   new(where: where) end
  def chain_where(additional_where) new(where: ("#{where} #{additional_where}")) end
  def set_order(order)   new(order: order) end
  def set_limit(limit)   new(limit: limit) end
  def set_offset(offset) new(offset: offset) end

  private
  attr_writer :select, :where, :order, :limit, :offset

  def new(attrs)
    p = { select: select, where: where, order: order, limit: limit, offset: offset }.merge(attrs)
    Query.new(p[:select], p[:where], p[:order], p[:limit], p[:offset])
  end
end
