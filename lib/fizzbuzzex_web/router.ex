defmodule FizzbuzzexWeb.Router do
  use FizzbuzzexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {FizzbuzzexWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FizzbuzzexWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources("/sessions", SessionController, only: [:new, :create])
    resources "/favourites", FavouriteController
  end

  # Other scopes may use custom stacks.
  scope "/api", FizzbuzzexWeb.Api, as: :api do
    pipe_through :api
    resources "/favourites", FavouriteController
  end
end
