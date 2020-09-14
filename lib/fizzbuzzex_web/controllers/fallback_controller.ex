defmodule FizzbuzzexWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use FizzbuzzexWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(FizzbuzzexWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, errors}) do
    conn
    |> assign(:errors, errors)
    |> put_status(422)
    |> put_view(FizzbuzzexWeb.ErrorView)
    |> render("error.json")
  end
end
