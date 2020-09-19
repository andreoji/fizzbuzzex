ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Fizzbuzzex.Repo, :auto)
{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, FizzbuzzexWeb.Endpoint.url)
