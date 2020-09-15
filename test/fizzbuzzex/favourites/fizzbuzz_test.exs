defmodule Fizzbuzzex.Favourites.Fizzbuzz.Test do
  use FizzbuzzexWeb.ConnCase
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Favourites.Fizzbuzz

  describe "current_page_numbers/2 when the page number is the last page to return the per_page count" do
    test "returns the numbers 99999999976 to 99999999990" do
      numbers = Fizzbuzz.current_page_numbers(6_666_666_666, 15)
      assert numbers == [
        %{state: false, number: 99999999976, fizzbuzz: "99999999976"},
        %{state: false, number: 99999999977, fizzbuzz: "99999999977"},
        %{state: false, fizzbuzz: "fizz", number: 99999999978},
        %{state: false, number: 99999999979, fizzbuzz: "99999999979"},
        %{state: false, fizzbuzz: "buzz", number: 99999999980},
        %{state: false, fizzbuzz: "fizz", number: 99999999981},
        %{state: false, number: 99999999982, fizzbuzz: "99999999982"},
        %{state: false, number: 99999999983, fizzbuzz: "99999999983"},
        %{state: false, fizzbuzz: "fizz", number: 99999999984},
        %{state: false, fizzbuzz: "buzz", number: 99999999985},
        %{state: false, number: 99999999986, fizzbuzz: "99999999986"},
        %{state: false, fizzbuzz: "fizz", number: 99999999987},
        %{state: false, number: 99999999988, fizzbuzz: "99999999988"},
        %{state: false, number: 99999999989, fizzbuzz: "99999999989"},
        %{state: false, fizzbuzz: "fizzbuzz", number: 99999999990}]
    end
  end

  describe "current_page_numbers/2 when the page number is the first page to return less than the per_page count" do
    test "returns the numbers 99999999991 to 100_000_000_000" do
      assert Fizzbuzz.current_page_numbers(6_666_666_667, 15) == last_ten()
    end
  end

  describe "current_page_numbers/2 when the page number and per_page would exceed 100_000_000_000" do
    test "still returns the last available numbers 99999999991 to 100_000_000_000" do
      assert Fizzbuzz.current_page_numbers(6_666_666_668, 15) == last_ten()
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
      %{state: false, number: 1, fizzbuzz: "1"},
      %{state: false, number: 2, fizzbuzz: "2"},
      %{state: false, number: 3, fizzbuzz: "fizz"},
      %{state: false, number: 4, fizzbuzz: "4"},
      %{state: false, number: 5, fizzbuzz: "buzz"}]
  end

  defp last_ten() do
    [
      %{state: false, number: 99999999991, fizzbuzz: "99999999991"},
      %{state: false, number: 99999999992, fizzbuzz: "99999999992"},
      %{state: false, number: 99999999993, fizzbuzz: "fizz"},
      %{state: false, number: 99999999994, fizzbuzz: "99999999994"},
      %{state: false, number: 99999999995, fizzbuzz: "buzz"},
      %{state: false, number: 99999999996, fizzbuzz: "fizz"},
      %{state: false, number: 99999999997, fizzbuzz: "99999999997"},
      %{state: false, number: 99999999998, fizzbuzz: "99999999998"},
      %{state: false, number: 99999999999, fizzbuzz: "fizz"},
      %{state: false, number: 100000000000, fizzbuzz: "buzz"}]
  end
end
