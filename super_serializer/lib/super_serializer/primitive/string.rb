# frozen_string_literal: true

##
# Primitive serializer for a *string*.
class SuperSerializer::Primitive::String < SuperSerializer::Primitive::Base
  def self.to_type_definition_with_references
    [
      TypeDefinition::Primitive.new("string"),
      {}
    ]
  end
end
