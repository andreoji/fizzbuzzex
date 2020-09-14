defmodule FizzbuzzexWeb.API.V1.FavouriteController do

  use FizzbuzzexWeb, :controller

  alias Fizzbuzzex.Favourites.{ListWorkflow, PostWorkflow}

  action_fallback FizzbuzzexWeb.FallbackController

  def index(conn, params) do
    {:ok, %{data: numbers, opts: opts}} = ListWorkflow.run(conn, params)
    conn
    |> put_status(200)
    |> render("index.json-api", data: numbers, opts: opts)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, params) do
    PostWorkflow.run(conn, params)
    |>
    case do
      {:ok, favourite} ->
        conn
        |> put_status(201)
        |> Plug.Conn.put_resp_header("location", Routes.favourite_path(conn, :show, favourite))
        |> render("show.json-api", data: favourite)
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
