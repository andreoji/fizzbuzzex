defmodule CustomBodyReader do
  def read_body(conn, _opts), do: {:ok, conn.assigns.raw_body, conn}
end
