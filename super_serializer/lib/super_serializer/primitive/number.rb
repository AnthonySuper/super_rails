# frozen_string_literal: true

##
# Primitive serializer for a *number*.
class SuperSerializer::Primitive::Number < SuperSerializer::Primitive::Base
  if defined?(SuperTyped)
    def self.type_definition
      SuperTyped::Definition::Primitive.new("number")
    end
  end
end
