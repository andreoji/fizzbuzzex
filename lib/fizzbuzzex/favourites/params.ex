defmodule Fizzbuzzex.Favourites.Params do

  @min_size 15
  @max_size 50

  def parse(%{"page" => %{"number" => number, "size" => size}}) do
    number = number |> parse_number
    size = size |> parse_size
    %{number: number, size: size}
  end
  def parse(%{"number" => number, "size" => size}) do
    number = number |> parse_number
    size = size |> parse_size
    %{number: number, size: size}
  end
  def parse(%{}), do: %{number: 1, size: @min_size}

  defp parse_number(number) do
    try do
      number = number |> String.to_integer
      number = if (number > 0), do: number, else: 1
      number
    rescue
      ArgumentError -> 1
    end
  end

  defp parse_size(size) do
    try do
      size = size |> String.to_integer
      size = if (size >= @min_size and size <= @max_size), do: size, else: @min_size
      size
    rescue
      ArgumentError -> @min_size
    end
  end
end
