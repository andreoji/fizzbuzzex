defmodule FizzbuzzexWeb.UserView do
  use FizzbuzzexWeb, :view

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.name}
  end
end
