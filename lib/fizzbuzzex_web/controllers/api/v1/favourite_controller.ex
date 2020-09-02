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
end
