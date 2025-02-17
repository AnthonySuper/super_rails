# frozen_string_literal: true

##
# Primitive serializer for a *number*.
class SuperSerializer::Primitive::Number < SuperSerializer::Primitive::Base
  def self.to_type_definition_with_references
    [
      TypeDefinition::Primitive.new("number"),
      {}
    ]
  end
end
