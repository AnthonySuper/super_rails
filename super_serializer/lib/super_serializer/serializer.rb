# frozen_string_literal: true

##
# Base interface for SuperSerializer compatible types.
module SuperSerializer::Serializer
  def as_json(opts = {})
    SuperSerializer::Writer::Value.new.tap do |writer|
      serialize_to_writer(writer, opts)
    end.result
  end

  def to_json(opts = {})
    (+"").tap do |buffer|
      SuperSerializer::Writer::JsonString.new(buffer).tap do |writer|
        serialize_to_writer(writer, opts)
      end
    end
  end

  def super_serializer? = true
end
