defmodule Fizzbuzzex.Accounts.Auth do
  alias Pow.Ecto.Schema.Password
  alias Fizzbuzzex.Repo

  def authenticate(username, password) do
    Fizzbuzzex.Accounts.User
    |> Repo.get_by(username: username)
    |> verify_password(password)
  end

  defp verify_password(nil, _password), do: {:error, :no_user_found}
  defp verify_password(%{password_hash: password_hash} = user, password) do
    case Password.pbkdf2_verify(password, password_hash) do
      true  -> {:ok, user}
      false -> {:error, :invalid_password}
    end
  end
end
