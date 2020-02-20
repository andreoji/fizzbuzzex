defmodule Fizzbuzzex.Favourites.Favourite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favourites" do
    field :number, :integer

    timestamps()
  end

  @doc false
  def changeset(favourite, attrs) do
    favourite
    |> cast(attrs, [:number])
    |> validate_required([:number])
  end
end
