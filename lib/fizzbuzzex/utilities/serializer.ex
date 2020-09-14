defmodule Fizzbuzzex.Utilities.Serializer do
  def to_attrs(data) do
    attrs = JaSerializer.Params.to_attributes(data)
    for {key, val} <- attrs, into: %{}, do: {String.to_atom(key), val}
  end
end
