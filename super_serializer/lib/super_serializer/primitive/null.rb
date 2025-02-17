# frozen_string_literal: true

##
# Serializes out a null in JSON.
class SuperSerializer::Primitive::Null < SuperSerializer::Primitive::Base
  if defined?(SuperTyped)
    def self.type_definition
      SuperTyped::Definition::Primitive.new("null")
    end
  end
end
