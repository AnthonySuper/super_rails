# frozen_string_literal: true

##
# Base class for *object serializers*.
class SuperSerializer::Object # rubocop:disable Metrics/ClassLength
  include SuperSerializer::Serializer
  extend SuperSerializer::SerializerDefinition

  class << self
    def attribute_serializers
      @attribute_serializers ||=
        if self == SuperSerializer::Object
          {}
        else
          superclass.attribute_serializers.dup
        end
    end

    def relationship_serializers
      @relationship_serializers ||=
        if self == SuperSerializer::Object
          {}
        else
          superclass.relationship_serializers.dup
        end
    end

    def attribute(name, type)
      type = resolve_type(type)
      attribute_serializers[name] = type
      define_delegated_method_for(name)

      name
    end

    def belongs_to(...) = has_one(...)

    def has_one(name, type) # rubocop:disable Naming/PredicateName
      type = resolve_type(type)
      define_delegated_method_for(name)
      relationship_serializers[name] = type

      name
    end

    def serializer_for_attribute(name)
      attribute_serializers.fetch(name)
    end

    def serializer_for_relationship(name)
      relationship_serializers.fetch(name)
    end

    def lookup_type_by_name(type)
      SuperSerializer::Primitive.lookup(type)
    end

    if defined?(SuperTyped)
      def type_definition
        if (name = referenced_type_name)
          SuperTyped::Definition::Referenced.new(
            name:,
            definition_proc: proc { object_definition }
          )
        else
          object_definition
        end
      end
    end

    def referenced_type_name = name

    private

    if defined?(SuperTyped)
      def object_definition
        SuperTyped::Definition::Object.new(
          properties: each_property_definition.to_a
        )
      end

      def each_property_definition # rubocop:disable Metrics/*
        return enum_for(__callee__) unless block_given?

        attribute_serializers.each do |name, serializer|
          yield SuperTyped::Definition::Property.new(
            name:, type: type_definition_for(serializer),
            required: true
          )
        end

        relationship_serializers.each do |name, serializer|
          yield SuperTyped::Definition::Property.new(
            name:, type: type_definition_for(serializer),
            required: false
          )
        end
      end
    end

    def resolve_type(type)
      type = lookup_type_by_name(type) if type.is_a?(Symbol)

      type
    end

    def define_delegated_method_for(name)
      define_method(name) { object.public_send(name) }
    end

    def define_attribute_type(name, type)
      type = SuperSerializer::Primitive.lookup(type) if type.is_a?(Symbol)

      attributes_type_map[name] = type
    end
  end

  def initialize(object)
    @object = object
  end

  attr_reader :object

  def relationship_names = self.class.relationship_serializers.keys
  def attribute_names = self.class.attribute_serializers.keys

  def serializer_for_attribute(...) = self.class.serializer_for_attribute(...)
  def serializer_for_relationship(...) = self.class.serializer_for_relationship(...)

  def serialize_to_writer(writer, opts = {}) # rubocop:disable Metrics/MethodLength
    writer.write_object do |object_writer|
      names = prepare_attribute_names(opts)

      names.each do |name|
        object_writer.write_attribute(
          name,
          public_send(name),
          serializer_for_attribute(name)
        )
      end

      extract_includes(opts) do |relationship_name, relationship_options|
        object_writer.write_attribute(
          relationship_name,
          public_send(relationship_name),
          serializer_for_relationship(relationship_name),
          relationship_options
        )
      end
    end
  end

  def serializable_attributes(names)
    names.index_with { |name| serialize_attribute(name) }.transform_keys(&:to_s)
  end

  def serialize_attribute(name)
    serializer_for_attribute(name).new(public_send(name)).as_json
  end

  def serialize_relationship(name, opts = {})
    serializer_for_relationship(name).new(public_send(name)).as_json(opts)
  end

  private

  def prepare_attribute_names(opts)
    names = attribute_names

    return names if opts.blank?

    if (only = opts[:only])
      names &= Array(only).map(&:to_sym)
    elsif (except = opts[:except])
      names -= Array(except).map(&:to_sym)
    end

    names
  end

  def extract_includes(opts, &block) # rubocop:disable Metrics/CyclomaticComplexity
    return if opts.nil?

    includes = opts[:include]

    return if includes.nil? || includes.blank?

    unless includes.is_a?(Hash)
      includes = Hash[Array(includes).flat_map { |n| n.is_a?(Hash) ? n.to_a : [[n, {}]] }]
    end

    includes.each(&block)
  end
end
