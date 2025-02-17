# frozen_string_literal: true

##
# A compound serializer that can *select* from one of several serializers.
# In order to maintain type information, the set of possible serializers must be *static*.
# So this class stores two things:
#
# 1. A hash of [Key -> Serializer]
# 2. A proc that transform [Object to be serialized -> Hash key]
class SuperSerializer::Compound::Select
  include SuperSerializer::SerializerDefinition

  ##
  # Actual, wrapped serializer.
  class Wrapped
    include SuperSerializer::Serializer

    def initialize(object, serializer)
      @object = object
      @serializer = serializer
    end

    def serialize_to_writer(writer, options)
      @serializer.new(@object).serialize_to_writer(writer, options)
    end
  end

  def initialize(serializer_map, select_proc)
    @serializer_map = serializer_map
    @select_proc = select_proc
  end

  attr_reader :serializer_map, :select_proc

  def type_definition
    TypeDefinition::OneOf.new(
      serializer_map.each_value.map { |val| type_definition_for(val) }
    )
  end

  def new(object)
    serializer = determine_serializer_for(object)

    SuperSerializer::Compound::Select::Wrapped.new(object, serializer)
  end

  def determine_serializer_for(object)
    serializer_map.fetch(
      select_proc.call(object)
    )
  end
end
