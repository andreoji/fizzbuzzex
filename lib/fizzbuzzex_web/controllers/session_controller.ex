defmodule FizzbuzzexWeb.SessionController do
  use FizzbuzzexWeb, :controller
  alias FizzbuzzexWeb.Endpoint

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => user, "password" => password}}) do
    case Fizzbuzzex.Auth.authenticate_user(user, password) do
      {:ok, user} ->
        conn
        |> Fizzbuzzex.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        #|> redirect(to: Routes.favourite_path(Endpoint, :new))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Fizzbuzzex.Auth.logout()
    |> redirect(to: Routes.page_path(Endpoint, :index))
  end
end
