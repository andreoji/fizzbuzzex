defmodule Fizzbuzzex.Repo.Migrations.CreateFavourites do
  use Ecto.Migration

  def change do
    create table(:favourites) do
      add :number, :bigint
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:favourites, [:user_id])
    create unique_index(:favourites, [:number, :user_id], name: :favourites_number_user_id_index)
  end
end
