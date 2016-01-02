defmodule DiscordElixir.API do
  use HTTPoison.Base

  @endpoint "https://discordapp.com/api"

  defp process_url(url), do: @endpoint <> url

  defp process_request_headers(headers) do
    headers
    |> add_json_headers
  end

  defp process_request_body(:empty), do: ""
  defp process_request_body(map), do: Poison.encode!(map)

  defp process_response_body(""), do: nil
  defp process_response_body(binary), do: Poison.decode!(binary)

  def token_header(token), do: [{"Authorization", token}]

  defp add_json_headers(headers) do
    [{"Accept", "application/json"},
     {"Content-Type", "application/json"} | headers]
  end
end
