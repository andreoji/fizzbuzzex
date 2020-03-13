defmodule FizzbuzzexWeb.FavouriteLive do
  use Phoenix.LiveView
  alias FizzbuzzexWeb.FavouriteView
  alias Fizzbuzzex.Favourites

  def render(assigns) do
    FavouriteView.render("favourites.html", assigns)
  end

  def mount(:not_mounted_at_router, %{"current_user" => _current_user, "page" => page, "per_page" => per_page}, socket) do
    params = {page, per_page} |> parse_params
    socket =
      socket
      |> assign(params)
      |> fetch
    {:ok, socket}
  end
  def mount(params, _session, socket) do
    params = params |> parse_params
    socket =
      socket
      |> assign(params)
      |> fetch
    {:ok, socket}
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
    %{page: page, per_page: per_page} = socket.assigns
    pagination = Favourites.current_page(page, per_page)
    assign(socket, pagination: pagination)
  end

  defp parse_params({page, per_page}) do
    page = page |> parse_page
    per_page = per_page |> parse_per_page
    %{page: page, per_page: per_page}
  end

  defp parse_params(params) do
    page = params |> parse_page
    per_page = params |> parse_per_page
    %{page: page, per_page: per_page}
  end

  defp parse_page(%{"page" => _page} = params) do
    {page, ""} = Integer.parse(params["page"] || "1")
    page
  end
  defp parse_page(%{}), do: 1
  defp parse_page(page) do
    {page, ""} = Integer.parse(page || "1")
    page
  end

  defp parse_per_page(%{"per_page" => _per_page} = params) do
    {per_page, ""} = Integer.parse(params["per_page"] || "15")
    per_page
  end
  defp parse_per_page(%{}), do: 15
  defp parse_per_page(per_page) do
    {per_page, ""} = Integer.parse(per_page || "15")
    per_page
  end
end
