defmodule Fizzbuzzex.Accounts.Test do
  use Fizzbuzzex.DataCase
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Accounts

  describe "create_user/1" do
    setup [:create_user]

    test "returns an error when full name is non-unique", %{
      user: user
    } do

      attrs = %{
        email: "jane@doe.com",
        name: user.name,
        username: "janed",
        password: "j123456d",
        password_confirmation: "j123456d"
      }
      {:error, changeset} = attrs |> Accounts.create_user
      assert %{name: ["has already been taken"]} = errors_on(changeset)
    end

    test "returns an error when username is non-unique", %{
      user: user
    } do

      attrs = %{
        email: "jane@doe.com",
        name: "jane doe",
        username: user.username,
        password: "j123456d",
        password_confirmation: "j123456d"
      }
      {:error, changeset} = attrs |> Accounts.create_user
      assert %{username: ["has already been taken"]} = errors_on(changeset)
    end

    test "returns an error when email is non-unique", %{
      user: user
    } do

      attrs = %{
        email: user.email,
        name: "jane doe",
        username: "janed",
        password: "j123456d",
        password_confirmation: "j123456d"
      }
      {:error, changeset} = attrs |> Accounts.create_user
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "returns a user when attrs are all valid" do
      attrs = %{
        email: "jane@doe.com",
        name: "jane doe",
        username: "janed",
        password: "j123456d",
        password_confirmation: "j123456d"
      }
      assert {:ok, u} = attrs |> Accounts.create_user
      assert u.name == attrs.name
      assert u.username == attrs.username
      assert u.email == attrs.email
    end
  end
end
