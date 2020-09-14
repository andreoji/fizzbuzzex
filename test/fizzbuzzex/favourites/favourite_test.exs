defmodule Fizzbuzzex.Favourites.FavouriteTest do
  use Fizzbuzzex.DataCase
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Favourites.Favourite
  alias Fizzbuzzex.Favourites.Fizzbuzz

  describe "changeset/2" do
    setup [:create_user_with_a_favourite_with_true_status]

    test "returns an error when creating the same favourite", %{
      user: user,
      favourite: favourite
    } do
      {:error, changeset} =
        %Favourite{user_id: user.id}
        |> Favourite.changeset(%{number: favourite.number, fizzbuzz: favourite.fizzbuzz, state: true})
        |> Repo.insert

      assert %{number_user_constraint: ["has already been taken"]} = errors_on(changeset)
    end

    test "creates a new favourite", %{
      user: user,
      favourite: favourite
    } do
      new_favourite = favourite.number + 1
      new_fizzbuzz =
        new_favourite
        |> Fizzbuzz.fizzbuzz
      assert {:ok, %Favourite{number: ^new_favourite, fizzbuzz: ^new_fizzbuzz}} =
        %Favourite{user_id: user.id}
        |> Favourite.changeset(%{number: new_favourite, fizzbuzz: new_fizzbuzz, state: true})
        |> Repo.insert
    end
  end
end
