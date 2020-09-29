defmodule FizzbuzzexWeb.TestHelpers.NamedSetup do
  import Ecto.Query, warn: false
  import FizzbuzzexWeb.TestHelpers.Factory
  alias Fizzbuzzex.Favourites.{Favourite, Fizzbuzz}
  alias Fizzbuzzex.Repo

  def log_user_in(context), do: do_log_user_in(context)

  def do_log_user_in(%{session: _session, user: user} = context) do
    context |> Map.merge(%{params: %{"name" => user.name}})
  end

  def do_log_user_in(%{session: _session} = context) do
    user = insert(:user)
    context |> Map.merge(%{params: %{"name" => user.name}, user: user})
  end

  def create_user(context) do
    user = insert(:user)
    context |> Map.merge(%{user: user})
  end

  def log_admin_in(context), do: do_log_admin_in(context)

  def do_log_admin_in(%{session: _session, admin: admin} = context) do
    context |> Map.merge(%{params: %{"name" => admin.name}})
  end

  def do_log_admin_in(%{session: _session} = context) do
    admin = insert(:admin)
    context |> Map.merge(%{params: %{"name" => admin.name}, admin: admin})
  end

  def create_admin(context) do
    admin = insert(:admin)
    context |> Map.merge(%{admin: admin})
  end

  def create_user_with_first_page_favourites(context) do
    user = insert(:user)
    _favourites =
    Enum.take_random(1..15, 5)
    |> Enum.map(fn number ->  insert(:favourite, user_id: user.id, number: number, fizzbuzz: number |> Fizzbuzz.fizzbuzz, state: true) end)
    user = user |> Repo.preload([favourites: (from f in Favourite, order_by: f.number)])
    context |> Map.merge(%{user: user})
  end

  def create_user_with_last_page_favourites(context) do
    user = insert(:user)
    favourites =
    Enum.take_random(99_999_999_991..Fizzbuzz.max, 5)
    |> Enum.map(fn number ->  insert(:favourite, user_id: user.id, number: number, fizzbuzz: number |> Fizzbuzz.fizzbuzz, state: true) end)
    user = user |> Repo.preload([favourites: (from f in Favourite, order_by: f.number)])
    context |> Map.merge(%{user: user, favourites: favourites})
  end

  def create_user_with_a_favourite_with_true_status(context) do
    user = insert(:user)
    number = Enum.random(1..Fizzbuzz.max)
    favourite = insert(:favourite, user_id: user.id, number: number, fizzbuzz: number |> Fizzbuzz.fizzbuzz, state: true)
    context |> Map.merge(%{user: user, favourite: favourite})
  end

  def create_user_with_a_favourite_with_false_status(context) do
    user = insert(:user)
    number = Enum.random(1..Fizzbuzz.max)
    favourite = insert(:favourite, user_id: user.id, number: number, fizzbuzz: number |> Fizzbuzz.fizzbuzz, state: false)
    context |> Map.merge(%{user: user, favourite: favourite})
  end

  def client_id_and_secret(text) do
    %{"id" => _id, "secret" => _secret} =
       Regex.named_captures(~r/ID: (?<id>[\s\S]*?)\nSecret: (?<secret>[\s\S]*?)\nScopes/, text)
  end

  def password_strategy_attrs(user, client_id, client_secret) do
    %{"client_id" => client_id,
    "client_secret" => client_secret,
    "grant_type" => "password",
    "username" => user.username,
    "password" => user.password}
  end

  def access_token(req_token_attrs) do
    {:ok, %{
      access_token: access_token,
      created_at: _created_at,
      expires_in: 7200,
      refresh_token: nil,
      scope: "",
      token_type: "bearer"
    }} = ExOauth2Provider.Token.grant(req_token_attrs, otp_app: :fizzbuzzex)
    access_token
  end
end
