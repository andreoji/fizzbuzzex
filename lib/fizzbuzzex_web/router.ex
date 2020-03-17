defmodule FizzbuzzexWeb.Router do
  use FizzbuzzexWeb, :router
  use Pow.Phoenix.Router

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

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", FizzbuzzexWeb do
    pipe_through :browser
    get "/", PageController, :index
  end

  scope "/", FizzbuzzexWeb do
    pipe_through [:browser, :protected]
    live "/favourites", FavouriteLive
  end

  # Other scopes may use custom stacks.
  scope "/api", FizzbuzzexWeb.Api, as: :api do
    pipe_through :api
    resources "/favourites", FavouriteController
  end
end
