# Fizzbuzzex

### Installation
  * Clone the Fizzbuzzex repo
  * Install dependencies with `mix deps.get`
  * Create, migrate and seed your database with `mix ecto.setup`
  
### Start Phoenix
  * Start the FizzbuzzexWeb endpoint with `mix phx.server`
  
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Description

This app fullfils the requirement of a Fizzbuzz web app and API written in Elixir.
Web users and API clients can paginate and favourite numbers between 1 and 100_000_000_000.

### Pagination

The pagination is custom written, page size can be changed via the url:

  * http://localhost:4000/favourites?page[number]=1&page[size]=15

  * http://localhost:4000/favourites?page[number]=1&page[size]=20

  * The max page size allowed is 100 which is also the default homepage size.

  * The min page size allowed is 15

### Phoenix Liveview

Liveview provides the core experience for web users


### JASON-API

API functionality follows the JASON-API specification

### A typical GET request:

```
http://localhost:4000/api/v1/favourites?page[number]=6666666667&page[size]=15
```

### JSON-API response:

```
{"data":[{"attributes":{"fizzbuzz":"99999999991","number":99999999991,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"99999999992","number":99999999992,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"fizz","number":99999999993,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"99999999994","number":99999999994,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"buzz","number":99999999995,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"fizz","number":99999999996,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"99999999997","number":99999999997,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"99999999998","number":99999999998,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"fizz","number":99999999999,"state":false},"id":"","type":"favourite"},{"attributes":{"fizzbuzz":"buzz","number":100000000000,"state":false},"id":"","type":"favourite"}],"jsonapi":{"version":"1.0"},"links":{"first":"/api/v1/favourites?page[number]=1&page[size]=15","prev":"/api/v1/favourites?page[number]=6666666666&page[size]=15","self":"/api/v1/favourites?page[number]=6666666667&page[size]=15"}}
```

