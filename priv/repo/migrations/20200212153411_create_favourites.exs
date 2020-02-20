defmodule Fizzbuzzex.Repo.Migrations.CreateFavourites do
  use Ecto.Migration

  def change do
    create table(:favourites) do
      add :number, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:favourites, [:user_id])
  end
end
