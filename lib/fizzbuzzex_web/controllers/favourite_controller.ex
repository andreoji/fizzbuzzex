defmodule FizzbuzzexWeb.FavouriteController do
  use FizzbuzzexWeb, :controller

  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Favourites.Favourite
  alias Phoenix.LiveView.Controller

  def index(conn, params) do
    Controller.live_render(conn, FizzbuzzexWeb.FavouriteLive, session: %{
      "current_user_id" => get_session(conn, :user_id)
    })
  end

  def new(conn, _params) do
    changeset = Favourites.change_favourite(%Favourite{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"favourite" => favourite_params}) do
    case Favourites.create_favourite(favourite_params) do
      {:ok, favourite} ->
        conn
        |> put_flash(:info, "Favourite created successfully.")
        |> redirect(to: Routes.favourite_path(conn, :show, favourite))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    favourite = Favourites.get_favourite!(id)
    render(conn, "show.html", favourite: favourite)
  end

  def edit(conn, %{"id" => id}) do
    favourite = Favourites.get_favourite!(id)
    changeset = Favourites.change_favourite(favourite)
    render(conn, "edit.html", favourite: favourite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "favourite" => favourite_params}) do
    favourite = Favourites.get_favourite!(id)

    case Favourites.update_favourite(favourite, favourite_params) do
      {:ok, favourite} ->
        conn
        |> put_flash(:info, "Favourite updated successfully.")
        |> redirect(to: Routes.favourite_path(conn, :show, favourite))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", favourite: favourite, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    favourite = Favourites.get_favourite!(id)
    {:ok, _favourite} = Favourites.delete_favourite(favourite)

    conn
    |> put_flash(:info, "Favourite deleted successfully.")
    |> redirect(to: Routes.favourite_path(conn, :index))
  end
end
