defmodule FizzbuzzexWeb.FavouriteLive do
  use Phoenix.LiveView
  alias FizzbuzzexWeb.FavouriteView
  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Favourites.Params


  def render(assigns) do
    FavouriteView.render("favourites.html", assigns)
  end

  def mount(:not_mounted_at_router, %{"current_user" => current_user, "page" => page, "per_page" => per_page}, socket) do
    params = %{"page" => page, "per_page" => per_page} |> Params.parse
    socket =
      socket
      |> assign(params)
      |> assign(current_user: current_user)
      |> fetch
    {:ok, socket}
  end

  def mount(%{"page" => _page, "per_page" => _per_page} = params, %{"current_user" => current_user}, socket) do
    params = params |> Params.parse
    socket =
      socket
      |> assign(params)
      |> assign(current_user: current_user)
      |> fetch
    {:ok, socket}
  end

  def mount(%{} = params, %{"current_user" => current_user}, socket) do
    params = params |> Params.parse
    socket =
      socket
      |> assign(params)
      |> assign(current_user: current_user)
      |> fetch
    {:ok, socket}
  end

  def handle_event("toggle_favourite", %{"number" => number}, %{assigns: %{current_user: current_user}} = socket) do
    _favourite = number |> Favourites.toggle_favourite(current_user)
    {:noreply, fetch(socket)}
  end

  def handle_event("next", _, %{assigns: %{pagination: pagination}} = socket) do
    socket =
      socket
      |> assign(page: pagination.next_page, per_page: pagination.per_page)
      |> fetch
    {:noreply, socket}
  end
  def handle_event("prev", _, %{assigns: %{pagination: pagination}} = socket) do
    socket =
      socket
      |> assign(page: pagination.prev_page, per_page: pagination.per_page)
      |> fetch
    {:noreply, socket}
  end

  defp fetch(socket) do
    %{page: page, per_page: per_page, current_user: current_user} = socket.assigns
    pagination = Favourites.current_page(page, per_page, current_user)
    assign(socket, pagination: pagination)
  end
end
