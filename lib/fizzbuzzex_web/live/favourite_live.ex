defmodule FizzbuzzexWeb.FavouriteLive do
  use Phoenix.LiveView
  alias FizzbuzzexWeb.FavouriteView
  alias Fizzbuzzex.Favourites

  def render(assigns) do
    FavouriteView.render("favourites.html", assigns)
  end

  def mount(:not_mounted_at_router, %{"current_user" => _current_user, "page" => page, "per_page" => per_page}, socket) do
    socket =
      socket
      |> assign_pagination({page, per_page})
      |> fetch
    {:ok, socket}
  end
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign_pagination(params)
      |> fetch
    {:ok, socket}
  end

  def handle_event("next", _, %{assigns: %{favourites: favourites}} = socket) do
    socket =
      socket
      |> assign(page: favourites.next_page, per_page: favourites.per_page)
      |> fetch
    {:noreply, socket}
  end
  def handle_event("prev", _, %{assigns: %{favourites: favourites}} = socket) do
    socket =
      socket
      |> assign(page: favourites.prev_page, per_page: favourites.per_page)
      |> fetch
    {:noreply, socket}
  end

  defp fetch(socket) do
    %{page: page, per_page: per_page} = socket.assigns
    favourites = Favourites.list_favourites(page, per_page)
    assign(socket, favourites: favourites)
  end

  defp assign_pagination(socket, {page, per_page}) do
    page = page |> parse_page
    per_page = per_page |> parse_per_page
    socket |> assign(page: page, per_page: per_page)
  end

  defp assign_pagination(socket, params) do
    page = params |> parse_page
    per_page = params |> parse_per_page
    socket |> assign(page: page, per_page: per_page)
  end

  defp parse_page(%{"page" => _page} = params) do
    {page, ""} = Integer.parse(params["page"] || "1")
    page
  end
  defp parse_page(page) do
    {page, ""} = Integer.parse(page || "1")
    page
  end

  defp parse_per_page(%{"per_page" => _per_page} = params) do
    {per_page, ""} = Integer.parse(params["per_page"] || "15")
    per_page
  end
  defp parse_per_page(per_page) do
    {per_page, ""} = Integer.parse(per_page || "15")
    per_page
  end
end
