defmodule Fizzbuzzex.Repo do
  use Ecto.Repo,
    otp_app: :fizzbuzzex,
    adapter: Ecto.Adapters.Postgres
end
