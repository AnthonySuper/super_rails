# frozen_string_literal: true

RSpec.describe "SuperSerializer::Object: basic usage" do
  let(:serializer) { SuperSerializer::SpecSupport::PersonSerializer }
  let(:person_instance) do
    SuperSerializer::SpecSupport::Person.new(first_name: "Rich", last_name: "Evans")
  end
  let(:expected_hash) do
    { "first_name" => "Rich", "last_name" => "Evans" }
  end

  it "has a good type definition" do
    expect(serializer.type_definition).to be_a(SuperSerializer::TypeDefinition::Referenced)
  end

  it "is a class" do
    expect(serializer).to be_a(Class)
  end

  specify "#as_json" do
    instance = serializer.new(person_instance)
    expect(instance.as_json).to eq(expected_hash)
  end

  specify "#to_json" do
    str = serializer.new(person_instance).to_json
    expect(JSON.parse(str)).to eq(expected_hash)
  end
end
