defmodule Fizzbuzzex.Favourites.Pagination do
  alias Fizzbuzzex.Favourites.Fizzbuzz

def page(page_number, size) do
    page_number =  to_int(page_number)
    size = to_int(size)
    numbers = Fizzbuzz.current_page_numbers(page_number, size)
    has_next =  (numbers |> List.last).number < Fizzbuzz.max
    has_prev = page_number > 1
    %{
      size: size,
      has_next: has_next,
      has_prev: has_prev,
      prev_page: page_number - 1,
      next_page: page_number + 1,
      page_number: page_number,
      first: numbers |> first_number,
      last: numbers |> last_number,
      count: Fizzbuzz.max,
      numbers: numbers
    }
  end

  defp to_int(param) when is_binary(param), do: param |> String.to_integer
  defp to_int(param), do: param

  defp first_number(numbers) do
    first =
      numbers
      |> List.first
    first.number
  end

  defp last_number(numbers) do
    last =
      numbers
      |> List.last
    last.number
  end
end
