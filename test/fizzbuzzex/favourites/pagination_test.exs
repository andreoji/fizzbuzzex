defmodule Fizzbuzzex.Favourites.Pagination.Test do
  use FizzbuzzexWeb.ConnCase
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Favourites.Pagination

  describe "page/2 when the page is the first page" do
    test "has the next page only" do
      page = Pagination.page(1, 15)
      refute page.has_prev
      assert page.has_next
      assert page.numbers == [
        %{state: false, number: 1, value: 1},
        %{state: false, number: 2, value: 2},
        %{state: false, number: 3, value: "fizz"},
        %{state: false, number: 4, value: 4},
        %{state: false, number: 5, value: "buzz"},
        %{state: false, number: 6, value: "fizz"},
        %{state: false, number: 7, value: 7},
        %{state: false, number: 8, value: 8},
        %{state: false, number: 9, value: "fizz"},
        %{state: false, number: 10, value: "buzz"},
        %{state: false, number: 11, value: 11},
        %{state: false, number: 12, value: "fizz"},
        %{state: false, number: 13, value: 13},
        %{state: false, number: 14, value: 14},
        %{state: false, number: 15, value: "fizzbuzz"}
      ]
    end
  end

  describe "page/2 when the page is the second page" do
    test "has both previous and next pages" do
      page = Pagination.page(2, 5)
      assert page.has_prev
      assert page.has_next
      assert page.numbers == [
        %{state: false, number: 6, value: "fizz"},
        %{state: false, number: 7, value: 7},
        %{state: false, number: 8, value: 8},
        %{state: false, number: 9, value: "fizz"},
        %{state: false, number: 10, value: "buzz"}
      ]
    end
  end

  describe "page/2 when the 100_000_000_000 max is reached for a page of 15" do
    test "has the previous page only" do
      page = Pagination.page(66_666_666_667, 15)
      assert page.has_prev
      refute page.has_next
      assert page.numbers == [
        %{state: false, number: 99999999991, value: 99999999991},
        %{state: false, number: 99999999992, value: 99999999992},
        %{state: false, number: 99999999993, value: "fizz"},
        %{state: false, number: 99999999994, value: 99999999994},
        %{state: false, number: 99999999995, value: "buzz"},
        %{state: false, number: 99999999996, value: "fizz"},
        %{state: false, number: 99999999997, value: 99999999997},
        %{state: false, number: 99999999998, value: 99999999998},
        %{state: false, number: 99999999999, value: "fizz"},
        %{state: false, number: 100000000000, value: "buzz"}
      ]
    end
  end
end
