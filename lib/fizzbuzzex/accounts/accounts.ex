defmodule Fizzbuzzex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Fizzbuzzex.Repo
  alias Fizzbuzzex.Accounts.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def create_admin_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> User.changeset_role(%{role: "admin"})
    |> Repo.insert()
  end

  def get_user(id) do
    User
    |> Repo.get(id)
  end
end
