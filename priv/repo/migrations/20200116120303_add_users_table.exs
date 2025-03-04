defmodule Fizzbuzzex.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :username, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string

      timestamps()
    end
    create unique_index(:users, [:username])
    create unique_index(:users, [:name])
    create unique_index(:users, [:email])
  end
end
