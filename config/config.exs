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
  render_errors: [view: FizzbuzzexWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Fizzbuzzex.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "ePN6ThxxJdSuhyFXFWn7KsqZwxVpD+4T"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

# Configures Guardian
config :fizzbuzzex, Fizzbuzzex.Auth.Guardian,
  issuer: "naive_dice",
  secret_key: "HNinpKh9Ne3tr8BpjCpAEh0xzCqTIG3PWsfkR2AtzvUaRIpbs6oIQ9RcmjmGPekJ"

config :fizzbuzzex, Fizzbuzzex.Auth.AuthAccessPipeline,
  module: Fizzbuzzex.Auth.Guardian,
  error_handler: Fizzbuzzex.Auth.AuthErrorHandler

config :fizzbuzzex, :pow,
  user: Fizzbuzzex.Accounts.User,
  repo: Fizzbuzzex.Repo,
  web_module: FizzbuzzexWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
