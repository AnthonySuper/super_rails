# frozen_string_literal: true

module SuperSerializer::TypeDefinition
  Primitive = Data.define(:type)

  Literal = Data.define(:value)

  Object = Data.define(:properties)

  Property = Data.define(:name, :type, :required)

  OneOf = Data.define(:variants)

  ArrayOf = Data.define(:items)

  Referenced = Data.define(:name, :definition_proc)

  Untyped = Data.define(:reference_class)
end
