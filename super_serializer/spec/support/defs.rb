# frozen_string_literal: true

module SuperSerializer::SpecSupport
  Person = Data.define(:first_name, :last_name)

  class PersonSerializer < SuperSerializer::Object
    attribute :first_name, :string
    attribute :last_name, :string
  end
end
