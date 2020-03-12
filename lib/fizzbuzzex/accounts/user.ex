defmodule Fizzbuzzex.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset
  alias Fizzbuzzex.Accounts.User

  @moduledoc false

  schema "users" do
    pow_user_fields()
    field(:name, :string)
    field(:username, :string)

    timestamps()
  end

  @doc false
  def create_changeset(%User{} = user, attrs) do
    user
    |> pow_changeset(attrs)
    |> cast(attrs,[:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 3, max: 10)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:username)
    |> unique_constraint(:name)
  end
end
