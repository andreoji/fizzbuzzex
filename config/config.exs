# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fizzbuzzex,
  ecto_repos: [Fizzbuzzex.Repo]

# Configures the endpoint
config :fizzbuzzex, FizzbuzzexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qu2WW07UahJf7ijZvdSkilWT7yZ4n5q8d0wzO66omPL7WNRDJVYdfddsrekM0IzY",
  render_errors: [view: FizzbuzzexWeb.ErrorView, accepts: ~w(html json json-api)],
  pubsub: [name: Fizzbuzzex.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "ePN6ThxxJdSuhyFXFWn7KsqZwxVpD+4T"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

config :fizzbuzzex, :pow,
  user: Fizzbuzzex.Accounts.User,
  repo: Fizzbuzzex.Repo,
  web_module: FizzbuzzexWeb

config :fizzbuzzex, ExOauth2Provider,
  repo: Fizzbuzzex.Repo,
  resource_owner: Fizzbuzzex.Accounts.User

config :fizzbuzzex, ExOauth2Provider,
  password_auth: {Fizzbuzzex.Accounts.Auth, :authenticate}

config :phoenix_oauth2_provider, PhoenixOauth2Provider,
  current_resource_owner: :current_user

config :phoenix, :format_encoders,
  "json-api": Jason

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
