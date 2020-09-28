defmodule Fizzbuzzex.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset
  alias Fizzbuzzex.Accounts.User
  alias Fizzbuzzex.Favourites.Favourite

  @moduledoc false

  schema "users" do
    field :role, :string, null: false, default: "user"
    pow_user_fields()
    field(:name, :string)
    field(:username, :string)
    has_many :favourites, Favourite
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

  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> cast(attrs, [:role])
    |> validate_inclusion(:role, ~w(user admin))
  end
end
