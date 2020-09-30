# Fizzbuzzex

### Installation
  * Clone the Fizzbuzzex repo
  * Install dependencies with `mix deps.get`
  * Edit the necessary files to configure your dev and test databases for you local postgres instance
  * Create, migrate and seed your database with `mix ecto.setup`

### Run the tests
  * `mix test`
  
### Start Phoenix
  * Start the FizzbuzzexWeb endpoint with `mix phx.server`
  
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

You can now login using

```
username: johnl",
password: j123456l"
```

## Description

This app fullfils the requirement of a Fizzbuzz web app and API written in Elixir.
Web users and API clients can follow links and favourite numbers between 1 and 100_000_000_000.

### Pagination

The pagination is custom written, page size can be changed via a url parameter:

  * http://localhost:4000/favourites?page[number]=1&page[size]=15

  * http://localhost:4000/favourites?page[number]=1&page[size]=20

  * The max page size allowed is 100 which is also the default homepage size.

  * The min page size allowed is 15

### Phoenix LiveView

Phoenix LiveView provides a rich, real-time user experience for web users.


### Fizzbuzzex API

As we are going to generate an access token, start the server interactively

`iex -S mix phx.server`

The API design follows the [`JSON:API`](https://jsonapi.org/format) specification

### Oauth2 application

  * Visit http://localhost:4000/oauth/applications.
  * Login with admind / a123456d.
  * Create a new application with `urn:ietf:wg:oauth:2.0:oob` as Redirect URI
  * Save the application, and take note of of the ID and Secret.
  
### Access token
  
Now we got everything to generate the access token.
Paste the following hash into the iex session once the values of `client_id` and `client_secret` have been changed for those of the newly created app, and press return.

```ruby
john_valid_request  = %{"client_id" => "ac30330db052feb6cc9122f8f1f1bf5c0d9b1b6c6b2ede9262e50da3b55d3a92",
                          "client_secret" => "ced16be7bb68a5e10779af5dc68cb100dc630c6a38c19fac9eb055289caccb06",
                          "grant_type" => "password",
                          "username" => "johnl",
                          "password" => "j123456l"}
```

Now paste the following into iex and press return:
```ruby
ExOauth2Provider.Token.grant(john_valid_request, otp_app: :fizzbuzzex)
```

You will get back an access token similar to the following:
```ruby
{:ok,
 %{
   access_token: "41aa68c9003946c7a0a198b3ea4a2923ab9156ea0c7d3eb3feba2a32cbfad471",
   created_at: ~N[2020-09-30 09:45:22],
   expires_in: 7200,
   refresh_token: nil,
   scope: "",
   token_type: "bearer"
 }}
```

### A typical GET request:

```
http://localhost:4000/api/v1/favourites?page[number]=6666666667&page[size]=15
```

### JSON-API response:

```
{"data":[{"attributes":{"fizzbuzz":"99999999991","number":99999999991,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"99999999992","number":99999999992,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"fizz","number":99999999993,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"99999999994","number":99999999994,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"buzz","number":99999999995,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"fizz","number":99999999996,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"99999999997","number":99999999997,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"99999999998","number":99999999998,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"fizz","number":99999999999,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"buzz","number":100000000000,"state":false},"id":"","type":"favourite"}],"jsonapi":{"version":"1.0"},"links":{"first":"/api/v1/favourites?page[number]=1&page[size]=15","prev":"/api/v1/favourites?page[number]=6666666666&page[size]=15","self":"/api/v1/favourites?page[number]=6666666667&page[size]=15"}}
```

