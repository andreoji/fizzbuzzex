defmodule FizzbuzzexWeb.Features.FavouritesTest do
  use FizzbuzzexWeb.FeatureCase
  use Wallaby.Feature
  alias FizzbuzzexWeb.TestHelpers.ApiClient

  setup [:log_user_in, :oauth2_token]

  test "when an api client requests the first page of favourites", %{access_token: access_token} do
    response = ApiClient.request(:get,
     "#{base_url()}/api/v1/favourites?page[number]=1&page[size]=15",
     "",
     [{"accept", "application/vnd.api+json"}], access_token)
    %{"data" => data, "links" => links}  = response |> json_body()

    assert %{status_code: 200} = response |> status_code()

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

  test "when an api client requests the last page of favourites", %{access_token: access_token} do
    response = ApiClient.request(:get,
     "#{base_url()}/api/v1/favourites?page[number]=6666666667&page[size]=15",
     "",
     [{"accept", "application/vnd.api+json"}], access_token)
    %{"data" => data, "links" => links}  = response |> json_body()

    assert %{status_code: 200} = response |> status_code()

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

  test "when an api client requests a page of favourites before the first available page",
   %{access_token: access_token} do
    response = ApiClient.request(:get,
     "#{base_url()}/api/v1/favourites?page[number]=-1&page[size]=15",
     "",
     [{"accept", "application/vnd.api+json"}], access_token)
    %{"data" => data, "links" => links}  = response |> json_body()

    assert %{status_code: 200} = response |> status_code()

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

  test "when an api client requests a page of favourites after the last available page", %{access_token: access_token} do
    response = ApiClient.request(:get,
     "#{base_url()}/api/v1/favourites?page[number]=6666666668&page[size]=15",
     "",
     [{"accept", "application/vnd.api+json"}], access_token)
    %{"data" => data, "links" => links}  = response |> json_body()

    assert %{status_code: 200} = response |> status_code()

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

  test "when an api client favourites a number", %{access_token: access_token} do
    payload =
    """
    {
      "data": {
        "type": "favourite",
        "attributes": {
          "number": 15,
          "fizzbuzz": "fizzbuzz",
          "state": true
        }
      }
    }
    """
    response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
    [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

    %{"data" => data}  = response |> json_body()

    assert %{
      "attributes" => %{"fizzbuzz" => "fizzbuzz", "number" => 15, "state" => true},
      "id" => id,
      "type" => "favourite"
    } = data

    assert %{status_code: 201} = response |> status_code()
  end

  test "when an api client unfavourites a number", %{access_token: access_token} do
    payload =
    """
    {
      "data": {
        "type": "favourite",
        "attributes": {
          "number": 15,
          "fizzbuzz": "fizzbuzz",
          "state": false
        }
      }
    }
    """
    response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
    [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

    %{"data" => data}  = response |> json_body()

    assert %{
      "attributes" => %{"fizzbuzz" => "fizzbuzz", "number" => 15, "state" => false},
      "id" => id,
      "type" => "favourite"
    } = data

    assert %{status_code: 201} = response |> status_code()
  end

  describe "errors" do
    test "when an api client gives the wrong fizzbuzz for a number", %{access_token: access_token} do
      payload =
      """
      {
        "data": {
          "type": "favourite",
          "attributes": {
            "number": 15,
            "fizzbuzz": "fizz",
            "state": true
          }
        }
      }
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      %{"errors" => errors}  = response |> json_body()

      assert [
        %{
          "detail" => "Fizzbuzz of 15 is fizzbuzz, incorrect value of fizz given.",
          "source" => %{"pointer" => "#/data/attributes/number"},
          "title" => "Invalid fizzbuzz value"
        }
      ] = errors

      assert %{status_code: 422} = response |> status_code()
    end

    test "when an api client gives a number less than 1", %{access_token: access_token} do
      payload =
      """
      {
        "data": {
          "type": "favourite",
          "attributes": {
            "number": 0,
            "fizzbuzz": "fizzbuzz",
            "state": true
          }
        }
      }
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      %{"errors" => errors}  = response |> json_body()

      assert [
        %{
          "detail" => "Number has to be in range 1 to 100000000000.",
          "source" => %{"pointer" => "#/data/attributes/number"},
          "title" => "Not in range"
        }
      ] = errors

      assert %{status_code: 422} = response |> status_code()
    end

    test "when an api client gives a number greater than 1_00_000_000_000", %{access_token: access_token} do
      payload =
      """
      {
        "data": {
          "type": "favourite",
          "attributes": {
            "number": 100000000001,
            "fizzbuzz": "100000000001",
            "state": true
          }
        }
      }
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      %{"errors" => errors}  = response |> json_body()

      assert [
        %{
          "detail" => "Number has to be in range 1 to 100000000000.",
          "source" => %{"pointer" => "#/data/attributes/number"},
          "title" => "Not in range"
        }
      ] = errors

      assert %{status_code: 422} = response |> status_code()
    end

    test "when an api client mismatches types", %{access_token: access_token} do
      payload =
      """
      {
        "data": {
          "type": "favourite",
          "attributes": {
            "number": "15",
            "fizzbuzz": 15,
            "state": "true"
          }
        }
      }
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      %{"errors" => errors}  = response |> json_body()

      assert [
        %{
          "detail" => "Type mismatch. Expected String but got Integer.",
          "source" => %{"pointer" => "#/data/attributes/fizzbuzz"},
          "title" => "Type mismatch"
        },
        %{
          "detail" => "Type mismatch. Expected Integer but got String.",
          "source" => %{"pointer" => "#/data/attributes/number"},
          "title" => "Type mismatch"
        },
        %{
          "detail" => "Type mismatch. Expected Boolean but got String.",
          "source" => %{"pointer" => "#/data/attributes/state"},
          "title" => "Type mismatch"
        }
      ] = errors

      assert %{status_code: 422} = response |> status_code()
    end

    test "when an api client gives the wrong value for type", %{access_token: access_token} do
      payload =
      """
      {
        "data": {
          "type": "meh",
          "attributes": {
            "number": 15,
            "fizzbuzz": "15",
            "state": true
          }
        }
      }
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      %{"errors" => errors}  = response |> json_body()

      assert [
        %{
          "detail" => ~s(Property type must have the value "favourite".),
          "source" => %{"pointer" => "#/data/type"},
          "title" => "Type's value incorrect"
        }
      ] = errors

      assert %{status_code: 422} = response |> status_code()
    end

    test "when an api client doesn't supply the type property", %{access_token: access_token} do
      payload =
      """
      {
        "data": {
          "attributes": {
            "number": 15,
            "fizzbuzz": "15",
            "state": true
          }
        }
      }
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      %{"errors" => errors}  = response |> json_body()

      assert [
        %{
          "detail" => "Required property type was not present.",
          "source" => %{"pointer" => "#/data"},
          "title" => "Invalid Properties"
        }
      ] = errors

      assert %{status_code: 422} = response |> status_code()
    end

    test "when an api client doesn't supply required attributes", %{access_token: access_token} do
      payload =
      """
      {
        "data": {
          "type": "favourite",
          "attributes": {
          }
        }
      }
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      %{"errors" => errors}  = response |> json_body()

      assert [
        %{
          "detail" => "Required properties number, fizzbuzz, state were not present.",
          "source" => %{"pointer" => "#/data/attributes"},
          "title" => "Invalid Attribute(s)"
        }
      ] = errors

      assert %{status_code: 422} = response |> status_code()
    end

    test "when an api client doesn't supply the attributes property", %{access_token: access_token} do
      payload =
      """
      {
        "data": {
          "type": "favourite"
        }
      }
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      %{"errors" => errors}  = response |> json_body()

      assert [
        %{
          "detail" => "Required property attributes was not present.",
          "source" => %{"pointer" => "#/data"}, "title" => "Invalid Properties"
        }
      ] = errors

      assert %{status_code: 422} = response |> status_code()
    end

    test "when an api client doesn't supply any data in the payload", %{access_token: access_token} do
      payload =
      """
      {}
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      %{"errors" => errors}  = response |> json_body()

      assert [
        %{
          "detail" => "Payload is required to have a data object.",
          "source" => %{"pointer" => "#/data"}, "title" => "Missing data"
        }
      ] = errors

      assert %{status_code: 422} = response |> status_code()
    end

    test "when an api client gives a malformed payload", %{access_token: access_token} do
      payload =
      """
      {
        "data": {
          "type": "favourite"
          "attributes": {
            "number": 15,
            "fizzbuzz": "fizzbuzz",
            "state": true
          }
        }
      }
      """
      response = ApiClient.request(:post,"#{base_url()}/api/v1/favourites", payload,
      [{"accept", "application/vnd.api+json"}, {"content-type", "application/vnd.api+json"}], access_token)

      assert "Bad Request" = response |> json_body()

      assert %{status_code: 400} = response |> status_code()
    end
  end

  def oauth2_token(%{session: session, user: user} = context) do
    email_field = fillable_field("user[email]")
    password_field = fillable_field("user[password]")
    oauth_application_name_field = fillable_field("oauth_application_name")
    oauth_application_redirect_uri_field = fillable_field("oauth_application_redirect_uri")

    show_application_page_text =
    session
    |> visit("/session/new")
    |> assert_has(css("h1", text: "Sign in"))
    |> assert_has(email_field)
    |> fill_in(email_field, with: user.email)
    |> fill_in(password_field, with: user.password)
    |> click(button("Sign in"))
    |> visit("/oauth/applications")
    |> assert_has(css("h1", text: "Your applications"))
    |> click(Query.link("New Application"))
    |> assert_has(css("h1", text: "New Application"))
    |> fill_in(oauth_application_name_field, with: "fizzbuzzex_client")
    |> fill_in(oauth_application_redirect_uri_field, with: "urn:ietf:wg:oauth:2.0:oob")
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
