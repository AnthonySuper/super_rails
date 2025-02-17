# frozen_string_literal: true

##
# Writes out to a ruby *value*.
class SuperSerializer::Writer::Value
  ##
  # Base class for compound object writers (IE, arrays and hashes)
  class CompoundWriter
    def serialize_value(value, serializer, options)
      case serializer
      when SuperSerializer::Primitive::Base
        value
      when SuperSerializer::SerializerDefinition
        SuperSerializer::Writer::Value.new.tap do |writer|
          serializer.serialize_to_writer(value, writer, options)
        end.result
      else
        value.as_json(options)
      end
    end
  end

  ##
  # Write values to a hash.
  class HashWriter < CompoundWriter
    def initialize
      super()
      @hash = {}
    end

    def result = @hash

    def write_attribute(name, value, serializer, options = {})
      @hash[name.to_s] = serialize_value(value, serializer, options)
    end
  end

  ##
  # Write values to an array
  class ArrayWriter < CompoundWriter
    def initialize
      super()
      @array = []
    end

    def result = @array

    def write_element(value, serializer, options = {})
      @array << serialize_value(value, serializer, options)
    end
  end

  def result = @value

  def write_primitive(value)
    @value = value
  end

  def write_object(&)
    @value = HashWriter.new.tap(&).result
  end

  def write_array(&)
    @value = ArrayWriter.new.tap(&).result
  end
end
