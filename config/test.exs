use Mix.Config

# Configure your database
config :fizzbuzzex, Fizzbuzzex.Repo,
  username: "andreo",
  password: "pa55w0rd",
  database: "fizzbuzzex_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fizzbuzzex, FizzbuzzexWeb.Endpoint,
  http: [port: 4002],
  server: true

config :fizzbuzzex, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn
