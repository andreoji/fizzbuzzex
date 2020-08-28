defmodule FizzbuzzexWeb.Router do
  use FizzbuzzexWeb, :router
  use Pow.Phoenix.Router
  use PhoenixOauth2Provider.Router, otp_app: :fizzbuzzex

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {FizzbuzzexWeb.LayoutView, :app}
    plug FizzbuzzexWeb.AssignUser
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api_protected do
    plug ExOauth2Provider.Plug.VerifyHeader, otp_app: :fizzbuzzex, realm: "Bearer"
    plug ExOauth2Provider.Plug.EnsureAuthenticated
  end

  pipeline :json_api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/" do
    pipe_through [:browser, :protected]

    oauth_routes()
  end

  scope "/", FizzbuzzexWeb do
    pipe_through :browser
    get "/", PageController, :index
  end

  scope "/", FizzbuzzexWeb do
    pipe_through [:browser, :protected]
    live "/favourites", FavouriteLive
  end

  scope "/" do
    pipe_through :api

    oauth_api_routes()
  end

  scope "/api/v1", FizzbuzzexWeb.API.V1 do
    pipe_through [:json_api, :api_protected]

    resources "/favourites", FavouriteController
  end
end
