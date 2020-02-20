defmodule FizzbuzzexWeb.FavouriteControllerTest do
  use FizzbuzzexWeb.ConnCase

  alias Fizzbuzzex.Favourites

  @create_attrs %{number: 42}
  @update_attrs %{number: 43}
  @invalid_attrs %{number: nil}

  def fixture(:favourite) do
    {:ok, favourite} = Favourites.create_favourite(@create_attrs)
    favourite
  end

  describe "index" do
    test "lists all favourites", %{conn: conn} do
      conn = get(conn, Routes.favourite_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Favourites"
    end
  end

  describe "new favourite" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.favourite_path(conn, :new))
      assert html_response(conn, 200) =~ "New Favourite"
    end
  end

  describe "create favourite" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.favourite_path(conn, :create), favourite: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.favourite_path(conn, :show, id)

      conn = get(conn, Routes.favourite_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Favourite"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.favourite_path(conn, :create), favourite: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Favourite"
    end
  end

  describe "edit favourite" do
    setup [:create_favourite]

    test "renders form for editing chosen favourite", %{conn: conn, favourite: favourite} do
      conn = get(conn, Routes.favourite_path(conn, :edit, favourite))
      assert html_response(conn, 200) =~ "Edit Favourite"
    end
  end

  describe "update favourite" do
    setup [:create_favourite]

    test "redirects when data is valid", %{conn: conn, favourite: favourite} do
      conn = put(conn, Routes.favourite_path(conn, :update, favourite), favourite: @update_attrs)
      assert redirected_to(conn) == Routes.favourite_path(conn, :show, favourite)

      conn = get(conn, Routes.favourite_path(conn, :show, favourite))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, favourite: favourite} do
      conn = put(conn, Routes.favourite_path(conn, :update, favourite), favourite: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Favourite"
    end
  end

  describe "delete favourite" do
    setup [:create_favourite]

    test "deletes chosen favourite", %{conn: conn, favourite: favourite} do
      conn = delete(conn, Routes.favourite_path(conn, :delete, favourite))
      assert redirected_to(conn) == Routes.favourite_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.favourite_path(conn, :show, favourite))
      end
    end
  end

  defp create_favourite(_) do
    favourite = fixture(:favourite)
    {:ok, favourite: favourite}
  end
end
