defmodule FizzbuzzexWeb.FeatureCase do

  use ExUnit.CaseTemplate
  use Phoenix.ConnTest

  using do
    quote do
      use Wallaby.DSL
      import Phoenix.ConnTest
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Wallaby.Query
      import FizzbuzzexWeb.TestHelpers.{Factory, NamedSetup}
      alias FizzbuzzexWeb.TestHelpers.ApiClient
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Fizzbuzzex.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Fizzbuzzex.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Fizzbuzzex.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
