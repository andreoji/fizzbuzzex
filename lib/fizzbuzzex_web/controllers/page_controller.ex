defmodule FizzbuzzexWeb.PageController do
  use FizzbuzzexWeb, :controller
  plug FizzbuzzexWeb.AssignUser

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
