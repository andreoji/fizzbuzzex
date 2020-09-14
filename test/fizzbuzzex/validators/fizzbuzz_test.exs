defmodule Fizzbuzzex.Validators.Favourites.Test do
  use Fizzbuzzex.DataCase
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Validators.Fizzbuzz

  test "validate_number/1 when number is in range" do
    assert :ok = %{number: 15, fizzbuzz: "fizzbuzz", state: true, type: "favourite"}
    |> Fizzbuzz.validate()
  end

  test "validate_number/1 when number is out of range" do
    assert {:error,
    [
      {"Number has to be in range 1 to 100000000000.", {"#/data/attributes/number", :not_in_range}}
    ]} =
    %{number: 0, fizzbuzz: "fizzbuzz", state: true, type: "favourite"}
    |> Fizzbuzz.validate()
  end

  test "validate_fizzbuzz/1 when fizzbuzz is invalid" do
    assert {:error,
    [
      {"Fizzbuzz of 15 is fizzbuzz, incorrect value of buzz given.", {"#/data/attributes/number", :invalid_fizzbuzz}}
    ]} =
    %{number: 15, fizzbuzz: "buzz", state: true, type: "favourite"}
    |> Fizzbuzz.validate()
  end

  test "validate_fizzbuzz/1 when number and fizzbuzz are both incorrect" do
    assert {:error,
    [
      {"Number has to be in range 1 to 100000000000.", {"#/data/attributes/number", :not_in_range}},
      {"Fizzbuzz of 100000000001 is 100000000001, incorrect value of buzz given.", {"#/data/attributes/number", :invalid_fizzbuzz}}
    ]} =
    %{number: 100_000_000_001, fizzbuzz: "buzz", state: true, type: "favourite"}
    |> Fizzbuzz.validate()
  end
end
