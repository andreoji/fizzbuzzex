defmodule Fizzbuzzex.Validators.JsonSchema do
  alias Fizzbuzzex.Favourites.Favourite
  import Ecto.Changeset

  def validate(json) do
    resolve_schema()
    |> ExJsonSchema.Validator.validate(json)
    |> case do
      :ok -> :ok
      {:error, errors} ->
        {:error, errors |> build_changeset}
    end
  end

  defp build_changeset(errors) do
    acc = change(%Favourite{})
    errors
    |> Enum.reduce(acc, fn t, acc -> t |> match_error(acc) end)
  end

  defp match_error({message, path}, acc) do
    cond do
      path |> String.ends_with?("number") ->
        _acc = acc |> add_error(:number, message)
      path |> String.ends_with?("fizzbuzz") ->
        _acc = acc |> add_error(:fizzbuzz, message)
      path |> String.ends_with?("state") ->
        _acc = acc |> add_error(:state, message)
      path |> String.ends_with?("type") ->
        _acc = acc |> add_error(:type, message)
      message |> String.match?(~r/number/) ->
        _acc = acc |> add_error(:attributes, message)
      message |> String.match?(~r/fizzbuzz/) ->
        _acc = acc |> add_error(:attributes, message)
      message |> String.match?(~r/state/) ->
        _acc = acc |> add_error(:attributes, message)
      message |> String.match?(~r/type/) ->
        _acc = acc |> add_error(:attributes, message)
      true -> acc
    end
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
