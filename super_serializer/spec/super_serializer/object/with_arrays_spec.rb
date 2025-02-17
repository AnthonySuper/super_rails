# frozen_string_literal: true

RSpec.describe "SuperSerializer::Object: basic usage with arrays" do
  let(:serializer) do
    SuperSerializer::SpecSupport::PersonSerializer.array
  end

  let(:person_array) do
    [

      SuperSerializer::SpecSupport::Person.new(first_name: "Mike", last_name: "Stoklassa"),
      SuperSerializer::SpecSupport::Person.new(first_name: "Rich", last_name: "Evans")
    ]
  end

  let(:expected_serialized) do
    [
      { "first_name" => "Mike", "last_name" => "Stoklassa" },
      { "first_name" => "Rich", "last_name" => "Evans" }
    ]
  end

  specify "#as_json" do
    serialized = serializer.new(person_array).as_json

    expect(serialized).to eq(expected_serialized)
  end

  specify "#to_json" do
    serialized = serializer.new(person_array).to_json

    expect(JSON.parse(serialized)).to eq(expected_serialized)
  end

  specify "#as_json with a nil element added" do
    serialized = SuperSerializer::SpecSupport::PersonSerializer.nullable.array.new([*person_array, nil]).as_json
    expect(serialized).to eq([*expected_serialized, nil])
  end
end
