defmodule Fizzbuzzex.Favourites.PostWorkflow do
  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Validators.{Fizzbuzz, JsonSchema}
  alias Fizzbuzzex.Utilities.Serializer

  def run(conn, %{"data" => data} = params) do
    with user <- conn |> ExOauth2Provider.Plug.current_resource_owner,
      :ok <- params |> JsonSchema.validate,
      attrs <- data |> Serializer.to_attrs,
      :ok <- attrs |> Fizzbuzz.validate do
        {:ok, _favourite} = attrs |> Favourites.upsert_favourite(user)
    end
  end

  def run(_conn, params) when params == %{}, do: JsonSchema.validate(params)
end
