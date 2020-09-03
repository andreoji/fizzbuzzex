defmodule Fizzbuzzex.Repo.Migrations.AddFizzbuzzToFavourites do
  use Ecto.Migration

  def change do
    alter table(:favourites) do
      add :fizzbuzz, :string
    end
  end
end
