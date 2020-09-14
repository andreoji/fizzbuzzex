defmodule Fizzbuzzex.Validators.JsonSchema do


  def validate(json) when json == %{}, do: {:error, [{"Payload is required to have a data object.", {"#/data", :missing_data_object}}]}
  def validate(json) do
    with :ok <- resolve_schema() |> ExJsonSchema.Validator.validate(json),
      :ok <- json |> validate_type do
      :ok
    else
      {:error, errors} ->
        json
        |> validate_type
        |> case do
          :ok -> {:error, errors}
          :missing_type_property ->
            {:error, errors}
          {:invalid_type, error} ->
            {:error, [error| errors]}

        end
      {:invalid_type, error} ->
        {:error, [error]}
      :missing_type_property ->
        {:error, []}
    end
  end

  defp validate_type(%{"data" => data} = _params) do
    attrs =
      data
      |> to_attrs()
      cond do
        attrs.type == "favourite" -> :ok
        attrs.type == nil -> :missing_type_property
        true ->
          {:invalid_type, {~s(Property type must have the value "favourite".), {"#/data/type", :invalid_type}}}
      end
  end

  defp to_attrs(data) do
    attrs = JaSerializer.Params.to_attributes(data)
    for {key, val} <- attrs, into: %{}, do: {String.to_atom(key), val}
  end

  defp resolve_schema() do
    ~s({
        "$schema": "http://json-schema.org/draft-04/schema",
        "$id": "http://example.com/example.json",
        "type": "object",
        "title": "The root schema",
        "description": "The root schema comprises the entire JSON document.",
        "required": [
          "data"
        ],
        "properties": {
          "data": {
            "$id": "#/properties/data",
            "type": "object",
            "title": "The data schema",
            "description": "The data representing a number including its type.",
            "required": [
              "type",
              "attributes"
            ],
            "properties": {
              "type": {
                "$id": "#/properties/data/properties/type",
                "type": "string",
                "title": "The type schema",
                "description": "An explanation about the purpose of this instance."
              },
              "attributes": {
                "$id": "#/properties/data/properties/attributes",
                "type": "object",
                "title": "The attributes schema",
                "description": "The attributes representing the overall state of a Fizzbuzz number.",
                "required": [
                  "number",
                  "fizzbuzz",
                  "state"
                ],
                "properties": {
                  "number": {
                    "$id": "#/properties/data/properties/attributes/properties/number",
                    "type": "integer",
                    "title": "The number schema",
                    "description": "The integer value has to be in the range 1..100_000_000_000."
                  },
                  "fizzbuzz": {
                    "$id": "#/properties/data/properties/attributes/properties/fizzbuzz",
                    "type": "string",
                    "title": "The fizzbuzz schema",
                    "description": "The fizzbuzz value of the integer."
                  },
                  "state": {
                    "$id": "#/properties/data/properties/attributes/properties/state",
                    "type": "boolean",
                    "title": "The state schema",
                    "description": "The state is a representation of whether the number is a favourite or not."
                  }
                }
              }
            }
          }
        }
    })
    |> Jason.decode!
  end
end
