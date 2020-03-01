defmodule FizzbuzzexWeb.PaginationHelpers do
  import Phoenix.HTML
  import Phoenix.HTML.Form
  import Phoenix.HTML.Link
  import Phoenix.HTML.Tag
  import Phoenix.LiveView.Helpers

  def pagination_text(list) do
    ~e"""
    Displaying <%= list.first.number %>-<%= list.last.number %> of <%= list.count %>
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
      live_patch("Previous", to: route.(socket, FizzbuzzexWeb.FavouriteLive, [page: list.prev_page, per_page: list.per_page]))
    end
  end

  defp do_next(socket, list, route) do
    content_tag :span do
      live_patch("Next", to: route.(socket, FizzbuzzexWeb.FavouriteLive, [page: list.next_page, per_page: list.per_page]))
    end
  end

  defp space, do: content_tag :span, do: raw("&nbsp")
end
