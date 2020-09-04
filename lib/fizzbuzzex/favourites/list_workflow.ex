defmodule Fizzbuzzex.Favourites.ListWorkflow do
  alias Fizzbuzzex.Favourites
  alias Fizzbuzzex.Favourites.Params

  def run(conn, params) do
    with %{number: number, size: size} <- params |> Params.parse,
      page <- Favourites.current_page(number, size, conn |> ExOauth2Provider.Plug.current_resource_owner),
      links <- %{number: number, size: size, total: page.count} |> JaSerializer.Builder.PaginationLinks.build(conn) do
        {:ok, %{data: page.numbers, opts: [page: links]}}
    end
  end
end
