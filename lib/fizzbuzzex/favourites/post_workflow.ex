defmodule Fizzbuzzex.Favourites.PostWorkflow do
  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Favourites.Fizzbuzz

  def run(conn, data) do
    with user <- conn |> ExOauth2Provider.Plug.current_resource_owner,
      attrs <- data |> to_attrs,
      {:ok, _message} <- attrs |> Fizzbuzz.validate_attributes do
      {:ok, _favourite} = attrs |> Favourites.upsert_favourite(user)
    end
  end

  defp to_attrs(data) do
    attrs = JaSerializer.Params.to_attributes(data)
    for {key, val} <- attrs, into: %{}, do: {String.to_atom(key), val}
  end
end
