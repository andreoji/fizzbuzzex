defmodule Fizzbuzzex.Favourites.Fizzbuzz.Test do
  use FizzbuzzexWeb.ConnCase
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Favourites.Fizzbuzz

  describe "current_page_numbers/2 when the page number is the last page to return the per_page count" do
    test "returns the numbers 999999999976 to 999999999990" do
      numbers = Fizzbuzz.current_page_numbers(66_666_666_666, 15)
      assert numbers == [
        %{state: false, number: 999999999976, value: 999999999976},
        %{state: false, number: 999999999977, value: 999999999977},
        %{state: false, value: "fizz", number: 999999999978},
        %{state: false, number: 999999999979, value: 999999999979},
        %{state: false, value: "buzz", number: 999999999980},
        %{state: false, value: "fizz", number: 999999999981},
        %{state: false, number: 999999999982, value: 999999999982},
        %{state: false, number: 999999999983, value: 999999999983},
        %{state: false, value: "fizz", number: 999999999984},
        %{state: false, value: "buzz", number: 999999999985},
        %{state: false, number: 999999999986, value: 999999999986},
        %{state: false, value: "fizz", number: 999999999987},
        %{state: false, number: 999999999988, value: 999999999988},
        %{state: false, number: 999999999989, value: 999999999989},
        %{state: false, value: "fizzbuzz", number: 999999999990}]
    end
  end

  describe "current_page_numbers/2 when the page number is the first page to return less than the per_page count" do
    test "returns the numbers 999999999991 to 100_0000_000_000" do
      assert Fizzbuzz.current_page_numbers(66_666_666_667, 15) == last_ten()
    end
  end

  describe "current_page_numbers/2 when the page number and per_page would exceed 100_0000_000_000" do
    test "still returns the last available numbers 999999999991 to 100_0000_000_000" do
      assert Fizzbuzz.current_page_numbers(66_666_666_668, 15) == last_ten()
    end
  end

  describe "current_page_numbers/2 when the page number is 1" do
    test "returns the first page" do
      assert Fizzbuzz.current_page_numbers(1, 5) == first_five()
    end
  end

  describe "current_page_numbers/2 when the page number is 0" do
    test "still returns the first page" do
      assert Fizzbuzz.current_page_numbers(0, 5) == first_five()
    end
  end

  describe "current_page_numbers/2 when the page number is negative" do
    test "still returns the first page" do
      assert Fizzbuzz.current_page_numbers(-1, 5) == first_five()
    end
  end

  defp first_five() do
    [
      %{state: false, number: 1, value: 1},
      %{state: false, number: 2, value: 2},
      %{state: false, number: 3, value: "fizz"},
      %{state: false, number: 4, value: 4},
      %{state: false, number: 5, value: "buzz"}]
  end

  defp last_ten() do
    [
      %{state: false, number: 999999999991, value: 999999999991},
      %{state: false, number: 999999999992, value: 999999999992},
      %{state: false, number: 999999999993, value: "fizz"},
      %{state: false, number: 999999999994, value: 999999999994},
      %{state: false, number: 999999999995, value: "buzz"},
      %{state: false, number: 999999999996, value: "fizz"},
      %{state: false, number: 999999999997, value: 999999999997},
      %{state: false, number: 999999999998, value: 999999999998},
      %{state: false, number: 999999999999, value: "fizz"},
      %{state: false, number: 1000000000000, value: "buzz"}]
  end
end
