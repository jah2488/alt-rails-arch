require 'test_helper'

class FieldTypeValidationErrorTest < MiniTest::Spec
  it 'provides a descriptive error message' do
    error = FieldTypeValidationError.new({ name: { type: String }}, { name: 999 }, :name)
    assert_equal error.message, "Field :name is expected to be type String, but you provided Fixnum"
  end
end

class ModelTest < Minitest::Spec
  class User < Model
    field :name, String
    field :age, Fixnum, 0
    field :accepted_tos, Boolean
  end
  class Sample < Model
    field :foo
    field :bar
  end

  it 'returns the type given to the field' do
    assert_equal Model.field(:name, String, 'foo user'), { type: String, default: 'foo user' }
  end

  it 'returns :no_validation flag if no type is given' do
    assert_equal Model.field(:foo), { type: :no_validation, default: nil }
  end

  it 'defines the initializer to take a hash of fields' do
    assert Sample.new(foo: 1, bar: [])
  end

  #TODO: Should actually validate that the default is the write type.
  it 'skips validations if a default is provided' do
    assert User.new(name: 'janey doe', accepted_tos: false) #Age has a default
  end

  it 'validates if boolean field is being set to literal true or false when Model::Boolean is used' do
    assert_raises(FieldTypeValidationError) { User.new(name: 'john doe', accepted_tos: 'sure') }
    assert_raises(FieldTypeValidationError) { User.new(name: 'john doe', accepted_tos:  0) }
    assert User.new(name: 'janey doe', accepted_tos: !"yes".blank?)
    assert User.new(name: 'janey doe', accepted_tos: true)
    assert User.new(name: 'janey doe', accepted_tos: false)
    assert User.new(name: 'janey doe', accepted_tos: !!nil)
  end

  it 'validates the type of each field' do
    assert User.new(name: 'jane doe', age: 45, accepted_tos: true)
    assert_raises(FieldTypeValidationError) do
      User.new(name: 999)
    end
  end

  it 'type_attributes method returns all fields with their types as hash' do
    assert_equal Sample.new.type_attributes, {
      foo: { type: :no_validation, default: nil },
      bar: { type: :no_validation, default: nil}
    }
    assert_equal User.new(name: 'jane doe', accepted_tos: false).type_attributes, {
      name: { type: String, default: nil },
      age:  { type: Fixnum, default: 0   },
      accepted_tos: { type: Model::Boolean, default: nil }
    }
  end
  it 'attributes method returns all fields with their types as hash' do
    assert_equal Sample.new.attributes, { foo: nil, bar: nil }
    assert_equal User.new(name: 'jane doe', accepted_tos: false).attributes, {
      name: 'jane doe',
      age: 0,
      accepted_tos: false 
    }
  end
end
