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
        %{state: false, number: 1, fizzbuzz: "1"},
        %{state: false, number: 2, fizzbuzz: "2"},
        %{state: false, number: 3, fizzbuzz: "fizz"},
        %{state: false, number: 4, fizzbuzz: "4"},
        %{state: false, number: 5, fizzbuzz: "buzz"},
        %{state: false, number: 6, fizzbuzz: "fizz"},
        %{state: false, number: 7, fizzbuzz: "7"},
        %{state: false, number: 8, fizzbuzz: "8"},
        %{state: false, number: 9, fizzbuzz: "fizz"},
        %{state: false, number: 10, fizzbuzz: "buzz"},
        %{state: false, number: 11, fizzbuzz: "11"},
        %{state: false, number: 12, fizzbuzz: "fizz"},
        %{state: false, number: 13, fizzbuzz: "13"},
        %{state: false, number: 14, fizzbuzz: "14"},
        %{state: false, number: 15, fizzbuzz: "fizzbuzz"}
      ]
    end
  end

  describe "page/2 when the page is the second page" do
    test "has both previous and next pages" do
      page = Pagination.page(2, 5)
      assert page.has_prev
      assert page.has_next
      assert page.numbers == [
        %{state: false, number: 6, fizzbuzz: "fizz"},
        %{state: false, number: 7, fizzbuzz: "7"},
        %{state: false, number: 8, fizzbuzz: "8"},
        %{state: false, number: 9, fizzbuzz: "fizz"},
        %{state: false, number: 10, fizzbuzz: "buzz"}
      ]
    end
  end

  describe "page/2 when the 100_000_000_000 max is reached for a page of 15" do
    test "has the previous page only" do
      page = Pagination.page(6_666_666_667, 15)
      assert page.has_prev
      refute page.has_next
      assert page.numbers == [
        %{state: false, number: 99999999991, fizzbuzz: "99999999991"},
        %{state: false, number: 99999999992, fizzbuzz: "99999999992"},
        %{state: false, number: 99999999993, fizzbuzz: "fizz"},
        %{state: false, number: 99999999994, fizzbuzz: "99999999994"},
        %{state: false, number: 99999999995, fizzbuzz: "buzz"},
        %{state: false, number: 99999999996, fizzbuzz: "fizz"},
        %{state: false, number: 99999999997, fizzbuzz: "99999999997"},
        %{state: false, number: 99999999998, fizzbuzz: "99999999998"},
        %{state: false, number: 99999999999, fizzbuzz: "fizz"},
        %{state: false, number: 100000000000, fizzbuzz: "buzz"}
      ]
    end
  end
end
