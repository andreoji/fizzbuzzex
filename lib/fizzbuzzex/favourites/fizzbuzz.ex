defmodule Fizzbuzzex.Favourites.Fizzbuzz do
  @min 1
  @max 100_000_000_000

  def current_page_numbers(page, per_page) do
    for n <- from(page, per_page)..to(page, per_page), do: %{number: n, value: fizzbuzz(n), state: false}
  end

  def from(page, per_page) when ((page * per_page) > @max) do
    if Integer.mod(@max, per_page) > 0 do
      (@max - Integer.mod(@max, per_page)) + 1
    else
      @max - (per_page - 1)
    end
  end
  def from(page, _per_page) when page < 1, do: @min
  def from(page, per_page), do: ((per_page * (page - 1)) + 1)

  def to(page, per_page) when ((page * per_page) > @max), do: @max
  def to(page, per_page) when page < 1, do: (1 * per_page)
  def to(page, per_page), do: (page * per_page)

  def fizzbuzz(n) do
    cond do
      rem(n, 15) == 0 -> "fizzbuzz"
      rem(n, 3) == 0 -> "fizz"
      rem(n, 5) == 0 -> "buzz"
      true -> n |> Integer.to_string()
    end
  end

  def validate_attributes(attrs) do
    fizzbuzz =
      attrs.number
      |> fizzbuzz
    cond do
      fizzbuzz == attrs.fizzbuzz  ->
        {:ok, "Fizzbuzz value match"}
      true -> {:error, %{error: "Fizzbuzz value is incorrect"}}
    end
  end

  def max, do: @max
  def min, do: @min
end
