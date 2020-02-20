defmodule Fizzbuzzex.Favourites.Pagination do
  import Ecto.Query
  alias Fizzbuzzex.Repo
  alias Fizzbuzzex.Favourites.Fizzbuzz

def page(page, per_page) do
    page =  page_to_int(page)
    per_page = per_page_to_int(per_page)
    numbers = Fizzbuzz.current_page_numbers(page, per_page)
    has_next = (length(numbers) == per_page)
    has_prev = page > 1
    %{
      per_page: per_page,
      has_next: has_next,
      has_prev: has_prev,
      prev_page: page - 1,
      next_page: page + 1,
      page: page,
      first: (page - 1) * per_page + 1,
      last: Enum.min([page * per_page, Fizzbuzz.max]),
      count: Fizzbuzz.max,
      list: numbers
    }
  end

  defp page_to_int(page) when is_binary(page), do: page |> String.to_integer
  defp page_to_int(page), do: page

  defp per_page_to_int(per_page) when is_binary(per_page), do: per_page |> String.to_integer
  defp per_page_to_int(per_page), do: per_page
end
