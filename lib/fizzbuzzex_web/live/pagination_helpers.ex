defmodule FizzbuzzexWeb.PaginationHelpers do
  import Phoenix.HTML
  import Phoenix.HTML.Link
  import Phoenix.HTML.Tag

  def pagination_text(favourites) do
    ~e"""
    Displaying <%= favourites.first.number %>-<%= favourites.last.number %> of <%= favourites.count %>
    """
  end

  def pagination_links(socket, list, route) do
    content_tag :div, class: "pagination" do
      socket |> links(list, route)
    end
  end

  defp links(socket, %{has_prev: false, has_next: true} = list, route), do: [do_next(socket, list, route)]
  defp links(socket, %{has_prev: true, has_next: false} = list, route), do: [do_prev(socket, list, route)]
  defp links(socket, %{has_prev: true, has_next: true} = list, route), do: [do_prev(socket, list, route), space(), do_next(socket, list, route)]

  defp do_prev(socket, list, route) do
    content_tag :span do
      link("Previous",
        to: route.(socket, FizzbuzzexWeb.FavouriteLive, [page: list.prev_page, per_page: list.per_page]),
        phx_click: :prev
      )
    end
  end

  defp do_next(socket, list, route) do
    content_tag :span do
      link("Next",
        to: route.(socket, FizzbuzzexWeb.FavouriteLive, [page: list.next_page, per_page: list.per_page]),
        phx_click: "next"
      )
    end
  end

  defp space, do: content_tag :span, do: raw("&nbsp")
end
