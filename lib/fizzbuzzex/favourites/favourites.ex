defmodule Fizzbuzzex.Favourites do
  @moduledoc """
  The Favourites context.
  """
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Repo
  alias Fizzbuzzex.Favourites.{Favourite, Pagination}

  def current_page(page_number, size, user) do
    pagination = Pagination.page(page_number, size)
    pagination
    |> users_favourites(user)
    |> case do
      [] -> pagination
      favourites ->
        %{pagination| numbers: Enum.map(pagination.numbers, fn number ->
            state_and_id = favourites |> state_and_id(number)
            number |> Map.merge(state_and_id)
      end)}
    end
  end

  defp state_and_id(favourites, n) do
    favourite =
      favourites
      |>
      Enum.find(& &1.number == n.number)
    favourite
    |> case do
      nil -> %{state: false, id: -1}
      %Favourite{} ->
        %{state: favourite.state, id: favourite.id}
    end
  end

  @spec toggle_favourite(any, atom | %{id: any}) :: any
  def toggle_favourite(number, user) do
    with favourite <- number |> get_favourite(user),
      {:ok, favourite} <- number |> do_toggle_favourite(user, favourite) do
      {:ok, favourite}
    else
      error -> error
    end
  end

  defp do_toggle_favourite(number, user, :no_favourite) do
    with favourite <- %Favourite{user_id: user.id} |> Favourite.changeset(%{state: true, number: number}),
      {:ok, favourite} <- favourite |> Repo.insert do
      {:ok, favourite}
    else
      error -> error
    end
  end

  defp do_toggle_favourite(_number, _user, %Favourite{state: state} = favourite) do
    with favourite <- favourite |> Ecto.Changeset.change(state: !state),
      {:ok, favourite} <- favourite |> Repo.update do
      {:ok, favourite}
    else
      error -> error
    end
  end

  defp get_favourite(number, user) do
    from(f in Favourite,
      where:  f.user_id == ^user.id and
              f.number == ^number
    )
    |> Repo.one
    |> case do
      nil -> :no_favourite
      favourite -> favourite
    end
  end

  defp users_favourites(pagination, user) do
    from(f in Favourite,
    where: f.user_id == ^user.id and
           f.number >= ^pagination.first and f.number <= ^pagination.last,
    order_by: [asc: f.number]
    )
    |> Repo.all
  end

  def upsert_favourite(attrs, user) do
    with favourite <- attrs.number |> get_favourite(user),
      {:ok, favourite} <- attrs |> do_upsert_favourite(user, favourite) do
      {:ok, favourite}
    else
      error -> error
    end
  end

  defp do_upsert_favourite(attrs, user, :no_favourite) do
    with favourite <- %Favourite{user_id: user.id} |> Favourite.changeset(%{state: attrs.state, number: attrs.number}),
      {:ok, favourite} <- favourite |> Repo.insert do
      {:ok, favourite}
    else
      error -> error
    end
  end

  defp do_upsert_favourite(attrs, _user, %Favourite{} = favourite) do
    with favourite <- favourite |> Ecto.Changeset.change(state: attrs.state |> to_bool),
      {:ok, favourite} <- favourite |> Repo.update do
      {:ok, favourite}
    else
      error -> error
    end
  end

  defp to_bool("true"), do: true
  defp to_bool("false"), do: false
end
