# frozen_string_literal: true

##
# Module containing information about "primitive types", which you can lookup via a symbol.
module SuperSerializer::Primitive
  class << self
    def registered_types
      @registered_types ||= {}
    end

    def register(name, type)
      registered_types[name] = type
    end

    def lookup(name)
      registered_types.fetch(name)
    end
  end

  register(:string, SuperSerializer::Primitive::String)
  register(:number, SuperSerializer::Primitive::Number)
  register(:null, SuperSerializer::Primitive::Null)
end
