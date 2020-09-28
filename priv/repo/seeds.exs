# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fizzbuzzex.Repo.insert!(%Fizzbuzzex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Fizzbuzzex.Accounts.create_user(%{
  name: "john lennon",
  username: "johnl",
  password: "j123456l",
  confirm_password: "j123456l",
  email: "john@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "paul mcartney",
  username: "paulm",
  password: "p123456m",
  confirm_password: "p123456m",
  email: "paul@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "george harrison",
  username: "georgeh",
  password: "g123456h",
  confirm_password: "g123456h",
  email: "george@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "ringo starr",
  username: "ringos",
  password: "r123456s",
  confirm_password: "r123456s",
  email: "ringo@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "mick jagger",
  username: "mickj",
  password: "m123456j",
  confirm_password: "m123456j",
  email: "mick@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "keith richards",
  username: "keithr",
  password: "k123456r",
  confirm_password: "k123456r",
  email: "keith@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "charlie watts",
  username: "charliew",
  password: "c123456w",
  confirm_password: "c123456w",
  email: "charlie@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "brian jones",
  username: "brianj",
  password: "b123456j",
  confirm_password: "b123456j",
  email: "brian@acme.com"
})

Fizzbuzzex.Accounts.create_admin_user(%{
  name: "admin doe",
  username: "admind",
  password: "a123456d",
  confirm_password: "a123456d",
  email: "admin@acme.com"
})
