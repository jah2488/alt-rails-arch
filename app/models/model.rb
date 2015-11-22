class FieldTypeValidationError < StandardError
  def initialize(attributes, fields, key)
    @attributes = attributes; @fields = fields; @key = key
  end

  def message
    "Field :#{@key} is expected to be type #{@attributes.fetch(@key).fetch(:type, 'unknown type')}, but you provided #{@fields[@key].class}"
  end
end

class Model
  class Boolean; end

  def self.field(name, type=:no_validation, default = nil)
    attr_reader name
    @attributes ||= {}
    @attributes[name] = { type: type, default: default }
  end

  define_method(:initialize) do |fields = {}|
    type_attributes.keys.each do |key|
      if type_attributes[key][:default].nil?
        unless type_attributes[key][:type] == :no_validation ||
               (type_attributes[key][:type] == Boolean && (fields[key] == true || fields[key] == false)) ||
               fields[key].is_a?(type_attributes[key][:type])
          raise FieldTypeValidationError.new(type_attributes, fields, key)
        end
      end
      instance_variable_set("@#{key}".to_sym, fields.fetch(key, type_attributes[key][:default]))
    end
  end

  def type_attributes
    self.class.instance_values["attributes"]
  end

  def attributes
    self.class.instance_values["attributes"].keys.zip(
      self.instance_variables.map do |ivar|
        instance_variable_get(ivar)
      end
    ).to_h
  end

  def ==(other)
    other.is_a?(self.class) && other.attributes == self.attributes
  end
end
