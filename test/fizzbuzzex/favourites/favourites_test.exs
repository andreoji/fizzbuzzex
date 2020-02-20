defmodule Fizzbuzzex.FavouritesTest do
  use Fizzbuzzex.DataCase

  alias Fizzbuzzex.Favourites

  describe "favourites" do
    alias Fizzbuzzex.Favourites.Favourite

    @valid_attrs %{number: 42}
    @update_attrs %{number: 43}
    @invalid_attrs %{number: nil}

    def favourite_fixture(attrs \\ %{}) do
      {:ok, favourite} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Favourites.create_favourite()

      favourite
    end

    test "list_favourites/0 returns all favourites" do
      favourite = favourite_fixture()
      assert Favourites.list_favourites() == [favourite]
    end

    test "get_favourite!/1 returns the favourite with given id" do
      favourite = favourite_fixture()
      assert Favourites.get_favourite!(favourite.id) == favourite
    end

    test "create_favourite/1 with valid data creates a favourite" do
      assert {:ok, %Favourite{} = favourite} = Favourites.create_favourite(@valid_attrs)
      assert favourite.number == 42
    end

    test "create_favourite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Favourites.create_favourite(@invalid_attrs)
    end

    test "update_favourite/2 with valid data updates the favourite" do
      favourite = favourite_fixture()
      assert {:ok, %Favourite{} = favourite} = Favourites.update_favourite(favourite, @update_attrs)
      assert favourite.number == 43
    end

    test "update_favourite/2 with invalid data returns error changeset" do
      favourite = favourite_fixture()
      assert {:error, %Ecto.Changeset{}} = Favourites.update_favourite(favourite, @invalid_attrs)
      assert favourite == Favourites.get_favourite!(favourite.id)
    end

    test "delete_favourite/1 deletes the favourite" do
      favourite = favourite_fixture()
      assert {:ok, %Favourite{}} = Favourites.delete_favourite(favourite)
      assert_raise Ecto.NoResultsError, fn -> Favourites.get_favourite!(favourite.id) end
    end

    test "change_favourite/1 returns a favourite changeset" do
      favourite = favourite_fixture()
      assert %Ecto.Changeset{} = Favourites.change_favourite(favourite)
    end
  end
end
