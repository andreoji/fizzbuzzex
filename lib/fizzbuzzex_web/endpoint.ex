defmodule FizzbuzzexWeb.Endpoint do

  use Phoenix.Endpoint, otp_app: :fizzbuzzex

  if Application.get_env(:fizzbuzzex, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  @session_options [
    store: :cookie,
    key: "_fizzbuzzex_key",
    signing_salt: "CrzMo2Ix"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]]

  socket "/socket", FizzbuzzexWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :fizzbuzzex,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded],
    pass: ["application/x-www-form-urlencoded", "application/vnd.api+json"],
    json_decoder: Phoenix.json_library()

  plug FizzbuzzexWeb.PrepareParse

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/vnd.api+json"],
    body_reader: {CustomBodyReader, :read_body, []},
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session, @session_options

  plug Pow.Plug.Session,
    otp_app: :fizzbuzzex,
    cache_store_backend: Pow.Store.Backend.MnesiaCache

  plug FizzbuzzexWeb.Router
end
