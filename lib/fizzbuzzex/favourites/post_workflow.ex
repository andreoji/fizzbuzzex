defmodule Fizzbuzzex.Favourites.PostWorkflow do
  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Validators.{Fizzbuzz, JsonSchema}

  def run(conn, %{"data" => data} = params) do
    with user <- conn |> ExOauth2Provider.Plug.current_resource_owner,
      :ok <- params |> JsonSchema.validate,
      attrs <- data |> to_attrs,
      :ok <- attrs |> Fizzbuzz.validate do
        {:ok, _favourite} = attrs |> Favourites.upsert_favourite(user)
    end
  end

  def run(_conn, params) when params == %{}, do: JsonSchema.validate(params)

  defp to_attrs(data) do
    attrs = JaSerializer.Params.to_attributes(data)
    for {key, val} <- attrs, into: %{}, do: {String.to_atom(key), val}
  end
end
