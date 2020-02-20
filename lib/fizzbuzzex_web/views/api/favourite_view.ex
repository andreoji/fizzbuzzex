defmodule FizzbuzzexWeb.Api.FavouriteView do
  use FizzbuzzexWeb, :view
  alias FizzbuzzexWeb.Api.FavouriteView

  def render("index.json", %{favourites: favourites}) do
    %{data: render_many(favourites, FavouriteView, "favourite.json")}
  end

  def render("show.json", %{favourite: favourite}) do
    %{data: render_one(favourite, FavouriteView, "favourite.json")}
  end

  def render("favourite.json", %{favourite: favourite}) do
    %{id: favourite.id,
      number: favourite.number}
  end
end
