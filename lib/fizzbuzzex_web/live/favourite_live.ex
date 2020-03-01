defmodule FizzbuzzexWeb.FavouriteLive do
  use Phoenix.LiveView
  alias FizzbuzzexWeb.FavouriteView
  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Favourites.Favourite
  import Fizzbuzzex.Auth, only: [load_current_user: 2]

  def render(assigns) do
    FavouriteView.render("index.html", assigns)
  end

  def mount(:not_mounted_at_router, session, socket) do
    {:ok, assign(socket, page: 1, per_page: 15)}
  end
  def mount(params, _session, socket) do
    {:ok, assign(socket, page: 1, per_page: 15)}
  end

  def handle_params(params, _url, socket) do
    {page, ""} = Integer.parse(params["page"] || "1")
    {per_page, ""} = Integer.parse(params["per_page"] || "15")
    {:noreply, socket |> assign(page: page, per_page: per_page) |> fetch()}
  end

  defp fetch(socket) do
    %{page: page, per_page: per_page} = socket.assigns
    favourites = Favourites.list_favourites(page, per_page)
    assign(socket, favourites: favourites)
  end
end
