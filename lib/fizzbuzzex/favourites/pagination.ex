defmodule Fizzbuzzex.Favourites.Pagination do
  import Ecto.Query
  alias Fizzbuzzex.Repo
  alias Fizzbuzzex.Favourites.Fizzbuzz

def page(page, per_page) do
    page =  to_int(page)
    per_page = to_int(per_page)
    numbers = Fizzbuzz.current_page_numbers(page, per_page)
    has_next =  (numbers |> List.last).number < Fizzbuzz.max
    has_prev = page > 1
    %{
      per_page: per_page,
      has_next: has_next,
      has_prev: has_prev,
      prev_page: page - 1,
      next_page: page + 1,
      page: page,
      first: numbers |> List.first,
      last: numbers |> List.last,
      count: Fizzbuzz.max,
      list: numbers
    }
  end

  defp to_int(p) when is_binary(p), do: p |> String.to_integer
  defp to_int(p), do: p
end
