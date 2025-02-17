# frozen_string_literal: true

##
# An array serializer, which uses another
# serializer and maps over an array with it.
class SuperSerializer::Compound::Array
  include SuperSerializer::SerializerDefinition

  ##
  # Actual serializer class.
  class Wrapped
    include SuperSerializer::Serializer

    def initialize(element_serializer, array)
      @element_serializer = element_serializer
      @array = array
    end

    attr_reader :element_serializer, :array

    def serialize_to_writer(writer, options)
      writer.write_array do |array_writer|
        array.each { |item| array_writer.write_element(item, element_serializer, options) }
      end
    end
  end

  def initialize(element_serializer)
    @element_serializer = element_serializer
  end

  attr_reader :element_serializer

  def new(array)
    SuperSerializer::Compound::Array::Wrapped.new(element_serializer, array)
  end

  if defined?(SuperTyped)
    def type_definition
      SuperTyped::Definition::ArrayOf.new(
        type_definition_for(element_serializer)
      )
    end
  end
end
