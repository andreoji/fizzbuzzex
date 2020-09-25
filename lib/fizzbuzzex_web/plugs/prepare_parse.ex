defmodule FizzbuzzexWeb.PrepareParse do
  import Plug.Conn
  @env Application.get_env(:fizzbuzzex, :env)
  @methods ~w(POST)

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    content_type = Plug.Conn.get_req_header(conn, "content-type")
    do_call(conn, opts, content_type)
  end
  defp do_call(conn, _opts, [content_type]) when content_type == "application/x-www-form-urlencoded", do: conn
  defp do_call(conn, opts, [content_type]) when content_type == "application/vnd.api+json" do
    %{method: method} = conn
    if method in @methods and not (@env in [:test]) do
      case Plug.Conn.read_body(conn, opts) do
        {:error, _} ->
          raise Plug.BadRequestError

        {:ok, "" = body, conn} ->
          update_in(conn.assigns[:raw_body], &[body | &1 || []])

        {:ok, body, conn} ->
          case Jason.decode(body) do
            {:ok, _result} ->
              update_in(conn.assigns[:raw_body], &[body | &1 || []])

            {:error, _reason} ->
              error = %{message: "Malformed JSON in the body"}
              render_error(conn, error)
          end
      end
    else
      conn
    end
  end
  defp do_call(conn, _opts, []), do: conn

  def render_error(conn, error) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(400, Jason.encode!(error))
    |> halt
  end
end
