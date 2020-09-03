defmodule FizzbuzzexWeb.API.V1.FavouriteController do
  use FizzbuzzexWeb, :controller

  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Favourites.Params

  action_fallback FizzbuzzexWeb.FallbackController

  def index(conn, params) do
    with %{number: number, size: size} <- params |> Params.parse,
      page <- Favourites.current_page(number, size, conn |> ExOauth2Provider.Plug.current_resource_owner),
      links <- %{number: number, size: size, total: page.count} |> JaSerializer.Builder.PaginationLinks.build(conn) do
        render conn, "index.json-api", data: page.numbers, opts: [page: links]
    else
      error -> error
    end
  end

  def create(conn, %{"data" => data}) do
    with user <- conn |> ExOauth2Provider.Plug.current_resource_owner,
      attrs <- data |> to_attrs,
      {:ok, favourite} <- attrs |> Favourites.upsert_favourite(user) do
        conn
        |> put_status(201)
        |> render("show.json-api", data: favourite)
    else
        {:error, error} ->
          conn
          |> put_status(422)
          |> render(:errors, data: error)
    end
  end

  defp to_attrs(data) do
    attrs = JaSerializer.Params.to_attributes(data)
    attrs = for {key, val} <- attrs, into: %{}, do: {String.to_atom(key), val}
  end
end
