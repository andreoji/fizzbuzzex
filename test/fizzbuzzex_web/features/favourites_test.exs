defmodule FizzbuzzexWeb.Features.FavouritesTest do
  use FizzbuzzexWeb.FeatureCase
  use Wallaby.Feature

  @email_field fillable_field("user[email]")
  @password_field fillable_field("user[password]")
  @oauth_application_name_field fillable_field("oauth_application_name")
  @oauth_application_redirect_uri_field fillable_field("oauth_application_redirect_uri")

  setup [:log_user_in, :oauth2_token]

  test "lists the first page of favourites", %{access_token: access_token} do
    response = ApiClient.request(:get,
     "http://localhost:4002/api/v1/favourites?page[number]=1&page[size]=15",
     [{"accept", "application/vnd.api+json"}], access_token)
    %{"data" => data, "links" => links}  = response |> ApiClient.json_body()

    assert %{status_code: 200} = response |> ApiClient.status_code()

    assert %{
      "attributes" => %{"fizzbuzz" => "1", "number" => 1, "state" => false},
      "id" => "",
      "type" => "favourite"
    } = data |> List.first

    assert %{
      "attributes" => %{"fizzbuzz" => "fizzbuzz", "number" => 15, "state" => false},
      "id" => "",
      "type" => "favourite"
    } = data |> List.last

    assert %{
      "last" => "/api/v1/favourites?page[number]=6666666667&page[size]=15",
      "next" => "/api/v1/favourites?page[number]=2&page[size]=15",
      "self" => "/api/v1/favourites?page[number]=1&page[size]=15"
    } = links
  end

  test "lists the last page of favourites", %{access_token: access_token} do
    response = ApiClient.request(:get,
     "http://localhost:4002/api/v1/favourites?page[number]=6666666667&page[size]=15",
     [{"accept", "application/vnd.api+json"}], access_token)
    %{"data" => data, "links" => links}  = response |> ApiClient.json_body()

    assert %{status_code: 200} = response |> ApiClient.status_code()

    assert %{
      "attributes" => %{"fizzbuzz" => "99999999991", "number" => 99999999991, "state" => false},
      "id" => "",
      "type" => "favourite"
    } = data |> List.first

    assert %{
      "attributes" => %{"fizzbuzz" => "buzz", "number" => 100000000000, "state" => false},
      "id" => "",
      "type" => "favourite"
    } = data |> List.last

    assert %{
      "first" => "/api/v1/favourites?page[number]=1&page[size]=15",
      "prev" => "/api/v1/favourites?page[number]=6666666666&page[size]=15",
      "self" => "/api/v1/favourites?page[number]=6666666667&page[size]=15"
    } = links
  end

  test "lists the first page of favourites when the page is before the first available",
   %{access_token: access_token} do
    response = ApiClient.request(:get,
     "http://localhost:4002/api/v1/favourites?page[number]=-1&page[size]=15",
     [{"accept", "application/vnd.api+json"}], access_token)
    %{"data" => data, "links" => links}  = response |> ApiClient.json_body()

    assert %{status_code: 200} = response |> ApiClient.status_code()

    assert %{
      "attributes" => %{"fizzbuzz" => "1", "number" => 1, "state" => false},
      "id" => "",
      "type" => "favourite"
    } = data |> List.first

    assert %{
      "attributes" => %{"fizzbuzz" => "fizzbuzz", "number" => 15, "state" => false},
      "id" => "",
      "type" => "favourite"
    } = data |> List.last

    assert %{
      "last" => "/api/v1/favourites?page[number]=6666666667&page[size]=15",
      "next" => "/api/v1/favourites?page[number]=2&page[size]=15",
      "self" => "/api/v1/favourites?page[number]=1&page[size]=15"
    } = links
  end

  test "lists the last page of favourites when the past the last available page", %{access_token: access_token} do
    response = ApiClient.request(:get,
     "http://localhost:4002/api/v1/favourites?page[number]=6666666668&page[size]=15",
     [{"accept", "application/vnd.api+json"}], access_token)
    %{"data" => data, "links" => links}  = response |> ApiClient.json_body()

    assert %{status_code: 200} = response |> ApiClient.status_code()

    assert %{
      "attributes" => %{"fizzbuzz" => "99999999991", "number" => 99999999991, "state" => false},
      "id" => "",
      "type" => "favourite"
    } = data |> List.first

    assert %{
      "attributes" => %{"fizzbuzz" => "buzz", "number" => 100000000000, "state" => false},
      "id" => "",
      "type" => "favourite"
    } = data |> List.last

    assert %{
      "first" => "/api/v1/favourites?page[number]=1&page[size]=15",
      "last" => "/api/v1/favourites?page[number]=6666666667&page[size]=15",
      "self" => "/api/v1/favourites?page[number]=6666666668&page[size]=15"
    } = links
  end

  def oauth2_token(%{session: session, user: user} = context) do
    show_application_page_text =
    session
    |> visit("/session/new")
    |> assert_has(css("h1", text: "Sign in"))
    |> assert_has(@email_field)
    |> fill_in(@email_field, with: user.email)
    |> fill_in(@password_field, with: user.password)
    |> click(button("Sign in"))
    |> visit("/oauth/applications")
    |> assert_has(css("h1", text: "Your applications"))
    |> click(Query.link("New Application"))
    |> assert_has(css("h1", text: "New Application"))
    |> fill_in(@oauth_application_name_field, with: "fizzbuzzex_client")
    |> fill_in(@oauth_application_redirect_uri_field, with: "urn:ietf:wg:oauth:2.0:oob")
    |> click(button("Save"))
    |> assert_has(css("h1", text: "Show Application"))
    |> Wallaby.Browser.text()

    access_token =
    show_application_page_text
    |> client_id_and_secret
    |> password_strategy_attrs(user)
    |> access_token

    context |> Map.merge(%{access_token: access_token})
  end
end
