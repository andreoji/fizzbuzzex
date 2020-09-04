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

  def create(conn, %{"data" => data}) do
    PostWorkflow.run(conn, data)
    |>
    case do
      {:ok, favourite} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: favourite)
      {:error, error} ->
        conn
        |> put_status(422)
        |> render(:errors, data: error)
    end
  end
end
