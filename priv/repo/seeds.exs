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
  password: "j123l",
  email: "john@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "paul mcartney",
  username: "paulm",
  password: "p123m",
  email: "paul@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "george harrison",
  username: "georgeh",
  password: "g123h",
  email: "george@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "ringo starr",
  username: "ringos",
  password: "r123s",
  email: "ringo@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "mick jagger",
  username: "mickj",
  password: "m123j",
  email: "mick@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "keith richards",
  username: "keithr",
  password: "k123r",
  email: "keith@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "charlie watts",
  username: "charliew",
  password: "c123w",
  email: "charlie@acme.com"
})

Fizzbuzzex.Accounts.create_user(%{
  name: "brian jones",
  username: "brianj",
  password: "b123j",
  email: "brian@acme.com"
})
