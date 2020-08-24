defmodule FizzbuzzexWeb.FavouriteLive do
  use Phoenix.LiveView
  alias FizzbuzzexWeb.FavouriteView
  alias Fizzbuzzex.Favourites

  @min_per_page 15
  @max_per_page 50

  def render(assigns) do
    FavouriteView.render("favourites.html", assigns)
  end

  def mount(:not_mounted_at_router, %{"current_user" => current_user, "page" => page, "per_page" => per_page}, socket) do
    params = %{"page" => page, "per_page" => per_page} |> parse_params
    socket =
      socket
      |> assign(params)
      |> assign(current_user: current_user)
      |> fetch
    {:ok, socket}
  end

  def mount(%{"page" => _page, "per_page" => _per_page} = params, %{"current_user" => current_user}, socket) do
    params = params |> parse_params
    socket =
      socket
      |> assign(params)
      |> assign(current_user: current_user)
      |> fetch
    {:ok, socket}
  end

  def mount(%{} = params, %{"current_user" => current_user}, socket) do
    params = params |> parse_params
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

  defp parse_params(%{"page" => page, "per_page" => per_page}) do
    page = page |> parse_page
    per_page = per_page |> parse_per_page
    %{page: page, per_page: per_page}
  end
  defp parse_params(%{}), do: %{page: 1, per_page: @min_per_page}

  defp parse_page(page) do
    try do
      page = page |> String.to_integer
      page = if (page > 0), do: page, else: 1
      page
    rescue
      ArgumentError -> 1
    end
  end

  defp parse_per_page(per_page) do
    try do
      per_page = per_page |> String.to_integer
      per_page = if (per_page >= @min_per_page and per_page <= @max_per_page), do: per_page, else: @min_per_page
      per_page
    rescue
      ArgumentError -> @min_per_page
    end
  end
end
