# frozen_string_literal: true

##
# Writes values to a JSON string.
class SuperSerializer::Writer::JsonString
  ##
  # Serializer for compound values.
  class CompoundWriter
    def initialize(buffer = +"")
      @buffer = buffer
    end

    def serialize_value(value, serializer, options)
      case serializer
      when SuperSerializer::Primitive::Base
        @buffer << value.to_json
      when SuperSerializer::SerializerDefinition
        SuperSerializer::Writer::JsonString.new(@buffer).tap do |writer|
          serializer.serialize_to_writer(value, writer, options)
        end.tap(&:finish!)
      else
        @buffer << value.to_json(options)
      end
    end
  end

  ##
  # Writes hash values directly to a buffer.
  class HashWriter < CompoundWriter
    def initialize(buffer = +"")
      super(buffer)
      @buffer << "{"
      @wrote_element = false
    end

    def write_attribute(name, value, serializer, options = {})
      @buffer << "," if @wrote_element

      @buffer << name.to_s.to_json
      @buffer << ":"
      serialize_value(value, serializer, options)
      @wrote_element = true
    end

    def finish!
      @buffer << "}"
    end
  end

  ##
  # Writes array values to a buffer.
  class ArrayWriter < CompoundWriter
    def initialize(buffer = +"")
      super(buffer)
      @wrote_element = false
      @buffer << "["
    end

    def write_element(value, serializer, options = {})
      @buffer << "," if @wrote_element
      @wrote_element = true
      serialize_value(value, serializer, options)
    end

    def finish!
      @buffer << "]"
    end
  end

  ##
  # No finishing to do.
  def finish!; end

  def result = @buffer

  def initialize(buffer = +"")
    @buffer = buffer
  end

  def write_primitive(value)
    @buffer << value.to_json
  end

  def write_object(&)
    HashWriter.new(@buffer).tap(&).finish!
  end

  def write_array(&)
    ArrayWriter.new(@buffer).tap(&).finish!
  end
end
