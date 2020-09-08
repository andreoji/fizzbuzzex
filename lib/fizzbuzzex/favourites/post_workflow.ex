defmodule Fizzbuzzex.Favourites.PostWorkflow do
  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Validators.{Fizzbuzz, JsonSchema}

  def run(conn, %{"data" => data} = params) do
    with user <- conn |> ExOauth2Provider.Plug.current_resource_owner,
      :ok <- params |> JsonSchema.validate,
      attrs <- data |> to_attrs,
      {:ok, _message} <- attrs |> Fizzbuzz.validate_type,
      {:ok, _message} <- attrs |> Fizzbuzz.validate_number,
      {:ok, _message} <- attrs |> Fizzbuzz.validate_fizzbuzz do
        {:ok, _favourite} = attrs |> Favourites.upsert_favourite(user)
    end
  end

  def run(_conn, %{} = params), do: Fizzbuzz.validate_data(params)

  defp to_attrs(data) do
    attrs = JaSerializer.Params.to_attributes(data)
    for {key, val} <- attrs, into: %{}, do: {String.to_atom(key), val}
  end
end
