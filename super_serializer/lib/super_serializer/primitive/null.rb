# frozen_string_literal: true

##
# Serializes out a null in JSON.
class SuperSerializer::Primitive::Null < SuperSerializer::Primitive::Base
  def self.to_type_definition_with_references
    [
      TypeDefinition::Primitive.new("null"),
      {}
    ]
  end
end
