defmodule FizzbuzzexWeb.TestHelpers.ApiClient do
  import FizzbuzzexWeb.TestHelpers.HttpHelper
  def request(verb, url, payload, headers, token), do: HTTPoison.request!(verb, url, payload, [bearer_auth_header(token)| headers])
end
