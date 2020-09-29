defmodule FizzbuzzexWeb.PaginationHelpers do
  import Phoenix.HTML
  import Phoenix.HTML.{Link, Tag}

  def pagination_text(pagination) do
    ~e"""
    Displaying page <%= pagination.page_number %> numbers (<%= pagination.first %>-<%= pagination.last %>) of <%= pagination.count %> pages
    """
  end

  def pagination_links(socket, pagination, route) do
    content_tag :div, class: "pagination" do
      socket |> links(pagination, route)
    end
  end

  defp links(socket, %{has_prev: false, has_next: true} = pagination, route), do: [do_next(socket, pagination, route)]
  defp links(socket, %{has_prev: true, has_next: false} = pagination, route), do: [do_prev(socket, pagination, route)]
  defp links(socket, %{has_prev: true, has_next: true} = pagination, route),
    do: [do_prev(socket, pagination, route), space(), do_next(socket, pagination, route)]

  defp do_prev(socket, pagination, route) do
    content_tag :span do
      link("Previous",
        to: route.(socket, FizzbuzzexWeb.FavouriteLive, page: [number: pagination.prev_page, size: pagination.size]),
        phx_click: :prev
      )
    end
  end

  defp do_next(socket, pagination, route) do
    content_tag :span do
      link("Next",
        to: route.(socket, FizzbuzzexWeb.FavouriteLive, page: [number: pagination.next_page, size: pagination.size]),
        phx_click: "next"
      )
    end
  end

  defp space, do: content_tag :span, do: raw("&nbsp")
end
