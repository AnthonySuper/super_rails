# frozen_string_literal: true

##
# Base class for primitive value serializers.
class SuperSerializer::Primitive::Base
  include SuperSerializer::Serializer
  extend SuperSerializer::SerializerDefinition

  def initialize(primitive)
    @primitive = primitive
  end

  def serialize_to_writer(writer, _opts = {})
    writer.write_primitive(@primitive)
  end
end
