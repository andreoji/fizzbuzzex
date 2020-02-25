defmodule Fizzbuzzex.Favourites.Pagination.Test do
  use FizzbuzzexWeb.ConnCase
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Favourites.Pagination

  describe "page/2 when the page is the first page" do
    test "has the next page only" do
      page = Pagination.page(1, 15)
      refute page.has_prev
      assert page.has_next
      assert page.list == [
        %{favourite: false, number: 1, value: 1},
        %{favourite: false, number: 2, value: 2},
        %{favourite: false, number: 3, value: "fizz"},
        %{favourite: false, number: 4, value: 4},
        %{favourite: false, number: 5, value: "buzz"},
        %{favourite: false, number: 6, value: "fizz"},
        %{favourite: false, number: 7, value: 7},
        %{favourite: false, number: 8, value: 8},
        %{favourite: false, number: 9, value: "fizz"},
        %{favourite: false, number: 10, value: "buzz"},
        %{favourite: false, number: 11, value: 11},
        %{favourite: false, number: 12, value: "fizz"},
        %{favourite: false, number: 13, value: 13},
        %{favourite: false, number: 14, value: 14},
        %{favourite: false, number: 15, value: "fizzbuzz"}
      ]
    end
  end

  describe "page/2 when the page is the second page" do
    test "has both previous and next pages" do
      page = Pagination.page(2, 5)
      assert page.has_prev
      assert page.has_next
      assert page.list == [
        %{favourite: false, number: 6, value: "fizz"},
        %{favourite: false, number: 7, value: 7},
        %{favourite: false, number: 8, value: 8},
        %{favourite: false, number: 9, value: "fizz"},
        %{favourite: false, number: 10, value: "buzz"}
      ]
    end
  end

  describe "page/2 when the 1_000_000_000_000 max is reached for a page of 15" do
    test "has the previous page only" do
      page = Pagination.page(66_666_666_667, 15)
      assert page.has_prev
      refute page.has_next
      assert page.list == [
        %{favourite: false, number: 999999999991, value: 999999999991},
        %{favourite: false, number: 999999999992, value: 999999999992},
        %{favourite: false, number: 999999999993, value: "fizz"},
        %{favourite: false, number: 999999999994, value: 999999999994},
        %{favourite: false, value: "buzz", number: 999999999995},
        %{favourite: false, number: 999999999996, value: "fizz"},
        %{favourite: false, number: 999999999997, value: 999999999997},
        %{favourite: false, number: 999999999998, value: 999999999998},
        %{favourite: false, number: 999999999999, value: "fizz"},
        %{favourite: false, number: 1000000000000, value: "buzz"}
      ]
    end
  end
end
