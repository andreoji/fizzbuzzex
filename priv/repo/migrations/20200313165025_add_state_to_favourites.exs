defmodule Fizzbuzzex.Repo.Migrations.AddStateToFavourites do
  use Ecto.Migration

  def change do
    alter table(:favourites) do
      add :state, :boolean, default: false
    end
  end
end
