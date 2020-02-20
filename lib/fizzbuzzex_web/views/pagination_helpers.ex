defmodule FizzbuzzexWeb.PaginationHelpers do
  import Phoenix.HTML
  import Phoenix.HTML.Form
  import Phoenix.HTML.Link
  import Phoenix.HTML.Tag

  def pagination_text(list) do
    ~e"""
    Displaying <%= list.first %>-<%= list.last %> of <%= list.count %>
    """
  end

  def pagination_links(conn, list, route) do
    content_tag :div, class: "pagination" do
      conn |> links(list, route)
    end
  end

  defp links(conn, %{has_prev: false, has_next: true} = list, route), do: [do_next(conn, list, route)]
  defp links(conn, %{has_prev: true, has_next: false} = list, route), do: [do_prev(conn, list, route)]
  defp links(conn, %{has_prev: true, has_next: true} = list, route), do: [do_prev(conn, list, route), space(), do_next(conn, list, route)]

  defp do_prev(conn, list, route) do
    content_tag :span do
      link("Previous", to: route.(conn, :index, [page: list.prev_page, per_page: list.per_page]))
    end
  end

  defp do_next(conn, list, route) do
    content_tag :span do
      link("Next", to: route.(conn, :index, [page: list.next_page, per_page: list.per_page]))
    end
  end

  defp space, do: content_tag :span, do: raw("&nbsp")
end
