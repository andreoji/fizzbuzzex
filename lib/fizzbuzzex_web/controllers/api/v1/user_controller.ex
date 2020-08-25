defmodule FizzbuzzexWeb.API.V1.UserController do
  use FizzbuzzexWeb, :controller

  alias Fizzbuzzex.Users
  alias Fizzbuzzex.Users.User

  action_fallback FizzbuzzexWeb.FallbackController

  def index(conn, _params) do
    users = [ExOauth2Provider.Plug.current_resource_owner(conn)]
    render(conn, "index.json", users: users)
  end
end
