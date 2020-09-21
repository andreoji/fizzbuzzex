defmodule FizzbuzzexWeb.TestHelpers.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Fizzbuzzex.Repo
  alias Fizzbuzzex.Accounts.User
  alias Fizzbuzzex.Favourites.Favourite
  alias Pow.Ecto.Schema.Password

  def user_factory do
    password = sequence(:password, &"j123456d#{&1}")
    %User{
      name: sequence(:name, &"john doe#{&1}"),
      username: sequence(:username, &"johnd#{&1}"),
      email: sequence(:email, &"john#{&1}@acme.com"),
      password: password,
      password_hash: password |> Password.pbkdf2_hash
    }
  end

  def favourite_factory do
    %Favourite{
      state: :false,
      user_id: build(:user)
    }
  end
end
