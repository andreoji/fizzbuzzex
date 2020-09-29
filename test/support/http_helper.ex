defmodule FizzbuzzexWeb.TestHelpers.HttpHelper do
  def status_code(response = %{}), do: response |> Map.take([:status_code])
  def body(%{body: body}), do: body
  def json_body(%{body: body}), do: body |> Poison.decode!
  def json_api_accept_header(), do: {"accept", "application/vnd.api+json"}
  def json_api_content_type_header(), do: {"Content-Type", "application/vnd.api+json"}
  def content_type_negotiation(), do: [json_api_accept_header(), json_api_content_type_header()]
  def bearer_auth_header(token), do: {"authorization", "Bearer #{token}"}
  def location(%{headers: headers}) do
    {"location", location_header} = Enum.find(headers, fn (x) -> match?({"location", _}, x) end)
    location_header
  end
  def base_url(), do: Application.get_env(:wallaby, :base_url)
end
