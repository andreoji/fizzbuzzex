defmodule FizzbuzzexWeb.API.V1.FavouriteView do
  use FizzbuzzexWeb, :view
  use JaSerializer.PhoenixView

  attributes [:number, :state, :fizzbuzz]
end
