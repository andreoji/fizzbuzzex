defmodule FizzbuzzexWeb.API.V1.FavouriteController do
  use FizzbuzzexWeb, :controller

  alias Fizzbuzzex.Favourites.Favourite
  alias Fizzbuzzex.Repo

  action_fallback FizzbuzzexWeb.FallbackController

  def index(conn, _params) do
    render conn, "index.json-api", data: Repo.all(Favourite)
  end
end
