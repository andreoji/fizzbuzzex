defmodule Fizzbuzzex.Favourites.Test do
  use Fizzbuzzex.DataCase
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Favourites.Favourite

  describe "current_page/2 when the first page has favourites" do
    setup [:create_user_with_first_page_favourites]

    test "returns a page with the correct favourites", %{
      user: user
    } do
      %{numbers: numbers} = Favourites.current_page(1, 15, user)
      page_favourites = numbers |> Enum.filter(& &1.state == true) |> Enum.map(& &1.number)
      user_favourites = user.favourites |> Enum.map(& &1.number)
      assert page_favourites == user_favourites
    end
  end

  describe "current_page/2 when the last page has favourites" do
    setup [:create_user_with_last_page_favourites]

    test "returns the last page with the correct favourites", %{
      user: user
    } do
      %{numbers: numbers} = Favourites.current_page(6_666_666_667, 15, user)
      page_favourites = numbers |> Enum.filter(& &1.state == true) |> Enum.map(& &1.number)
      user_favourites = user.favourites |> Enum.map(& &1.number)
      assert page_favourites == user_favourites
    end
  end

  describe "toggle_favourite/2 when the favourite's state is initially true" do
    setup [:create_user_with_a_favourite_with_true_status]

    test "toggles the favourite's state to false ", %{
      user: user,
      favourite: favourite
    } do
      assert {:ok, %Favourite{state: false}} = Favourites.toggle_favourite(favourite.number, user)
    end
  end

  describe "toggle_favourite/2 when the favourite's state is initially false" do
    setup [:create_user_with_a_favourite_with_false_status]

    test "toggles the favourite's state to true ", %{
      user: user,
      favourite: favourite
    } do
      assert {:ok, %Favourite{state: true}} = Favourites.toggle_favourite(favourite.number, user)
    end
  end

  describe "toggle_favourite/2 when the number has never been a favourite" do
    setup [:create_user]

    test "creates a favourite's with a state of true ", %{
      user: user
    } do
      number = 10
      assert {:ok, %Favourite{state: true, number: number}} = Favourites.toggle_favourite(number, user)
    end
  end
end
