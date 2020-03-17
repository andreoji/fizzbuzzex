defmodule FizzbuzzexWeb.AssignUser do
  import Plug.Conn

  alias Fizzbuzzex.Accounts.User
  alias Fizzbuzzex.Repo

  def init(opts), do: opts

  def call(conn, params) do
    case Pow.Plug.current_user(conn) do
      %User{} =
        user ->
          put_session(conn, "current_user", Repo.preload(user, params[:preload] || []))
        _ ->
          put_session(conn, "current_user", nil)
    end
  end
end
