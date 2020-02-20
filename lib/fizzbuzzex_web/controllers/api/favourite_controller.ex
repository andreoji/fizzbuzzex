defmodule FizzbuzzexWeb.Api.FavouriteController do
  use FizzbuzzexWeb, :controller

  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Favourites.Favourite

  action_fallback FizzbuzzexWeb.FallbackController

  def index(conn, _params) do
    favourites = Favourites.list_favourites()
    render(conn, "index.json", favourites: favourites)
  end

  def create(conn, %{"favourite" => favourite_params}) do
    with {:ok, %Favourite{} = favourite} <- Favourites.create_favourite(favourite_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_favourite_path(conn, :show, favourite))
      |> render("show.json", favourite: favourite)
    end
  end

  def show(conn, %{"id" => id}) do
    favourite = Favourites.get_favourite!(id)
    render(conn, "show.json", favourite: favourite)
  end

  def update(conn, %{"id" => id, "favourite" => favourite_params}) do
    favourite = Favourites.get_favourite!(id)

    with {:ok, %Favourite{} = favourite} <- Favourites.update_favourite(favourite, favourite_params) do
      render(conn, "show.json", favourite: favourite)
    end
  end

  def delete(conn, %{"id" => id}) do
    favourite = Favourites.get_favourite!(id)

    with {:ok, %Favourite{}} <- Favourites.delete_favourite(favourite) do
      send_resp(conn, :no_content, "")
    end
  end
end
