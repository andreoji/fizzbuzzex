defmodule FizzbuzzexWeb.TestHelpers.NamedSetup do
  import Ecto.Query, warn: false
  import FizzbuzzexWeb.Factory
  alias Fizzbuzzex.Favourites.Favourite
  alias Fizzbuzzex.Repo

  @max 100_000_000_000

  def create_user(context) do
    user = insert(:user)
    context |> Map.merge(%{user: user})
  end

  def create_user_with_first_page_favourites(context) do
    user = insert(:user)
    _favourites =
    Enum.take_random(1..15, 5)
    |> Enum.map(fn number ->  insert(:favourite, user_id: user.id, number: number, state: true) end)
    user = user |> Repo.preload([favourites: (from f in Favourite, order_by: f.number)])
    context |> Map.merge(%{user: user})
  end

  def create_user_with_last_page_favourites(context) do
    user = insert(:user)
    favourites =
    Enum.take_random(99_999_999_991..@max, 5)
    |> Enum.map(fn number ->  insert(:favourite, user_id: user.id, number: number, state: true) end)
    user = user |> Repo.preload([favourites: (from f in Favourite, order_by: f.number)])
    context |> Map.merge(%{user: user, favourites: favourites})
  end

  def create_user_with_a_favourite_with_true_status(context) do
    user = insert(:user)
    number = Enum.random(1..@max)
    favourite = insert(:favourite, user_id: user.id, number: number, state: true)
    context |> Map.merge(%{user: user, favourite: favourite})
  end

  def create_user_with_a_favourite_with_false_status(context) do
    user = insert(:user)
    number = Enum.random(1..@max)
    favourite = insert(:favourite, user_id: user.id, number: number, state: false)
    context |> Map.merge(%{user: user, favourite: favourite})
  end
end
