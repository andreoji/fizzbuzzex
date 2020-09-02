defmodule FizzbuzzexWeb.FavouriteLive do
  use Phoenix.LiveView
  alias FizzbuzzexWeb.FavouriteView
  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Favourites.Params


  def render(assigns) do
    FavouriteView.render("favourites.html", assigns)
  end

  def mount(:not_mounted_at_router, %{"current_user" => current_user, "number" => _number, "size" => _size} = params, socket) do
    params = params |> Params.parse
    socket =
      socket
      |> assign(params)
      |> assign(current_user: current_user)
      |> fetch
    {:ok, socket}
  end

  def mount(%{"page" => %{"number" => _number, "size" => _size}} = params, %{"current_user" => current_user}, socket) do
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
      |> assign(number: pagination.next_page, size: pagination.size)
      |> fetch
    {:noreply, socket}
  end
  def handle_event("prev", _, %{assigns: %{pagination: pagination}} = socket) do
    socket =
      socket
      |> assign(number: pagination.prev_page, size: pagination.size)
      |> fetch
    {:noreply, socket}
  end

  defp fetch(socket) do
    %{number: number, size: size, current_user: current_user} = socket.assigns
    pagination = Favourites.current_page(number, size, current_user)
    assign(socket, pagination: pagination)
  end
end
