defmodule Fizzbuzzex.Favourites.Params do

  @min_per_page 15
  @max_per_page 50

  def parse(%{"page" => %{"number" => number, "size" => size}}) do
    number = number |> page
    size = size |> per_page
    %{number: number, size: size}
  end
  def parse(%{"page" => page, "per_page" => per_page}) do
    page = page |> page
    per_page = per_page |> per_page
    %{page: page, per_page: per_page}
  end
  def parse(%{}), do: %{page: 1, per_page: @min_per_page}

  defp page(page) do
    try do
      page = page |> String.to_integer
      page = if (page > 0), do: page, else: 1
      page
    rescue
      ArgumentError -> 1
    end
  end

  defp per_page(per_page) do
    try do
      per_page = per_page |> String.to_integer
      per_page = if (per_page >= @min_per_page and per_page <= @max_per_page), do: per_page, else: @min_per_page
      per_page
    rescue
      ArgumentError -> @min_per_page
    end
  end
end
