# frozen_string_literal: true

##
# Primitive serializer for a *string*.
class SuperSerializer::Primitive::String < SuperSerializer::Primitive::Base
  if defined?(SuperTyped)
    def self.type_definition
      SuperTyped::Definition::Primitive.new("string")
    end
  end
end
