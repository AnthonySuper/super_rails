# frozen_string_literal: true

##
# Module that provides common functionality for serializer *definitions*.
module SuperSerializer::SerializerDefinition
  ##
  # Makes this serializer nullable.
  # If the input object is `nil`, serialize out a `null` in json.
  # Otherwise, use this serializer.
  def nullable
    SuperSerializer::Compound::Select.new(
      {
        true => SuperSerializer::Primitive::Null,
        false => self
      },
      :nil?.to_proc
    )
  end

  ##
  # Promotes this serializer to serialize *arrays* instead.
  def array
    SuperSerializer::Compound::Array.new(self)
  end

  def serialize_to_writer(value, writer, opts = {})
    new(value).serialize_to_writer(writer, opts)
  end

  def serialize_to_value(value, opts = {})
    SuperSerializer::Writer::Value.new.tap do |writer|
      serialize_to_writer(value, writer, opts)
    end.result
  end

  private

  if defined?(SuperType)
    def type_definition_for(other_serializer)
      if other_serializer.respond_to?(:type_definition)
        other_serializer.type_definition
      else
        TypeDefinition::Untyped.new(other_serializer)
      end
    end
  end
end
