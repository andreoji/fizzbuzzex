defmodule FizzbuzzexWeb.FeatureCase do

  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Wallaby.Query
      import FizzbuzzexWeb.TestHelpers.{Factory, NamedSetup}
      import FizzbuzzexWeb.TestHelpers.HttpHelper
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
