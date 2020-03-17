defmodule Fizzbuzzex.Favourites.Favourite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favourites" do
    field :number, :integer
    field :user_id, :id
    field :state, :boolean

    timestamps()
  end

  @doc false
  def changeset(favourite, attrs) do
    favourite
    |> cast(attrs, [:number, :state])
    |> validate_required([:number, :state])
    |> unique_constraint(:number_user_constraint, name: :favourites_number_user_id_index)
  end
end
